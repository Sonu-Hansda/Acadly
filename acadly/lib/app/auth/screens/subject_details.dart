import 'dart:convert';
import 'package:acadly/app/common/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class SubjectDetails extends StatefulWidget {
  final String subjectId;
  final String subjectName;
  final String professor;
  final String credits;

  const SubjectDetails({
    super.key,
    required this.subjectId,
    required this.subjectName,
    required this.professor,
    required this.credits,
  });

  @override
  State<SubjectDetails> createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  List<Map<String, dynamic>> notes = [];
  bool isLoading = false;

  final String baseUrl = "http://localhost:3000/api/subjects";

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }
  Future<void> fetchNotes() async {
    try {
      setState(() => isLoading = true);
      final response = await http.get(
        Uri.parse("$baseUrl/${widget.subjectId}/notes"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          notes = List<Map<String, dynamic>>.from(data['notes'] ?? []);
        });
      } else {
        print("Error fetching notes: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching notes: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> uploadFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result == null) return;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/${widget.subjectId}/notes"),
      );

      for (var file in result.files) {
        if (file.path != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'files',
            file.path!,
            filename: file.name,
          ));
        }
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload successful!")),
        );
        fetchNotes();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Error uploading files: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading files: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.subjectName),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.subjectName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text("Professor: ${widget.professor}",
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text("Credits: ${widget.credits}",
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Uploaded Notes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : notes.isEmpty
                  ? const Center(
                child: Text(
                  "No notes uploaded yet!",
                  style: TextStyle(color: AppColors.textLight, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(
                        Icons.picture_as_pdf,
                        color: Colors.redAccent,
                      ),
                      title: Text(note['title'] ?? 'Untitled'),
                      subtitle: Text(
                        note['uploadedBy'] ?? '',
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () async {
                        final url = note['url'];
                        if (url != null && url.isNotEmpty) {
                          final uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Could not open file")),
                            );
                          }
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: uploadFiles,
        icon: const Icon(Icons.upload_file),
        label: const Text("Upload Notes"),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
