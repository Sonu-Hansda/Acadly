import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class SubjectDetails extends StatefulWidget {
  final String subjectName;
  final String professor;
  final String credits;

  const SubjectDetails({
    super.key,
    required this.subjectName,
    required this.professor,
    required this.credits,
  });

  @override
  State<SubjectDetails> createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails> {
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    loadFiles();
  }

  Future<void> loadFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final subjectFolder = Directory("${directory.path}/${widget.subjectName}");
    if (await subjectFolder.exists()) {
      setState(() {
        files = subjectFolder.listSync();
      });
    } else {
      await subjectFolder.create(recursive: true);
    }
  }

  Future<void> pickAndSaveFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final directory = await getApplicationDocumentsDirectory();
      final subjectFolder = Directory("${directory.path}/${widget.subjectName}");
      if (!(await subjectFolder.exists())) {
        await subjectFolder.create(recursive: true);
      }

      final filePath = result.files.single.path!;
      final fileName = result.files.single.name;
      final newFile = File("${subjectFolder.path}/$fileName");

      await File(filePath).copy(newFile.path);
      loadFiles();
    }
  }

  Future<void> deleteFile(File file) async {
    await file.delete();
    loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.subjectName),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // --- Subject Info Card ---
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
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
                        color: Colors.deepPurple,
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

            Text(
              "Uploaded Files",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: files.isEmpty
                  ? const Center(
                child: Text(
                  "No files uploaded yet!",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  final fileName = file.path.split('/').last;

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: Icon(
                        fileName.endsWith('.pdf')
                            ? Icons.picture_as_pdf
                            : Icons.insert_drive_file,
                        color: Colors.redAccent,
                      ),
                      title: Text(fileName),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () => deleteFile(File(file.path)),
                      ),
                      onTap: () {
                        // Optionally open PDF or file viewer
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
        onPressed: pickAndSaveFile,
        icon: const Icon(Icons.upload_file),
        label: const Text("Upload File"),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}


