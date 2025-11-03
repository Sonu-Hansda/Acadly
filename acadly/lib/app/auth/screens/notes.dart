import 'dart:io';
import 'package:acadly/app/auth/screens/subject_details.dart';
import 'package:flutter/material.dart';
import '../../../utils/variable.dart';
import '../../common/theme/colors.dart';
import 'package:path_provider/path_provider.dart';
import '../../common/theme/typography.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
TextEditingController myController = TextEditingController();
final TextEditingController subjectController = TextEditingController();
final TextEditingController professorController = TextEditingController();
final TextEditingController creditsController = TextEditingController();

@override
  void initState() {
    super.initState();
    myController.addListener((){
      setState(() {});
    });
  }

  List<Map<String,dynamic>> get filteredNotes {
    final query= myController.text.toLowerCase().trim();
    return notes.where((notes){
      final title = notes['title'].toString().toLowerCase();
      final matchesSearch = query.isEmpty || title.contains(query);
      return matchesSearch;
    }).toList();
  }

Future<void> createSubjectFolder(String subjectName) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = Directory("${directory.path}/$subjectName");

  if (!(await path.exists())) {
    await path.create(recursive: true);
  }
}


void showAddSubjectDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

        title: Text(
          "Add New Subject",
          style: AppTypography.headline2.copyWith(
            color: AppColors.text,
          ),
        ),

        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: subjectController,
                decoration: InputDecoration(
                  labelText: "Subject Name",
                  labelStyle: AppTypography.bodyText2,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: professorController,
                decoration: InputDecoration(
                  labelText: "Professor",
                  labelStyle: AppTypography.bodyText2,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: creditsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Credits",
                  labelStyle: AppTypography.bodyText2,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: AppTypography.button.copyWith(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  final subjectName = subjectController.text.trim();
                  final professor = professorController.text.trim();
                  final credits = creditsController.text.trim();

                  if (subjectName.isNotEmpty) {
                    setState(() {
                      notes.add({
                        "title": subjectName,
                        "professor": professor,
                        "credits": credits,
                      });
                    });
                    await createSubjectFolder(subjectName);
                    subjectController.clear();
                    professorController.clear();
                    creditsController.clear();

                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Add",
                  style: AppTypography.button.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notes and PYQ',
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(color: AppColors.accent),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
          padding: EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: myController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Expanded(
              child: filteredNotes.isEmpty? Center(child: Text("Nothing found!"),):
              GridView.builder(
                itemCount: filteredNotes.length,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 220,
                ),
                itemBuilder: (context, index) {
                  final subject = filteredNotes[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubjectDetails(
                            subjectName: subject['title'],
                            professor: subject['professor'],
                            credits: subject['credits'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: AppColors.background, // optional from your theme
                      shadowColor: AppColors.primary.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_copy_rounded,
                              color: AppColors.accent,
                              size: 70,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              subject['title'],
                              style: AppTypography.headline2.copyWith(
                                fontSize: 18,
                                color: AppColors.text,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Professor: ${subject['professor']}",
                              style: AppTypography.bodyText2.copyWith(
                                color: AppColors.textLight,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Credits: ${subject['credits']}",
                              style: AppTypography.bodyText2.copyWith(
                                color: AppColors.textLight,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddSubjectDialog,
        child: Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
