import 'package:flutter/material.dart';
import '../../../utils/variable.dart';
import '../../common/theme/colors.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
TextEditingController myController = TextEditingController();

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
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
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
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    mainAxisExtent: 300,
                  ),
                  itemBuilder: (context,index){
                    final subject = filteredNotes[index];
                    return GridTile(child: Column(
                      children: [
                        Icon(Icons.picture_as_pdf,color: Colors.red, size: 75,),
                        Text(subject['title']),
                      ],
                    ));
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
