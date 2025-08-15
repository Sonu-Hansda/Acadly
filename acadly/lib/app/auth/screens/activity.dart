import 'package:flutter/material.dart';
import '../../../utils/variable.dart';
import '../../common/theme/colors.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {

  String selectedValue = "Today";
  String selectedValue1 = "Assignments";
  List<String> options = ['General', 'Assignments'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Activity and Notification',
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(color: AppColors.accent),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: ShapeDecoration(
                      shape: Theme.of(context).inputDecorationTheme.enabledBorder
                      is OutlineInputBorder
                          ? Theme.of(context).inputDecorationTheme.enabledBorder!
                      as OutlineInputBorder
                          : const OutlineInputBorder(),
                    ),
                    child: DropdownButton<String>(
                      value: selectedValue,
                      isExpanded: true, // so it takes full width inside container
                      underline: SizedBox(), // removes default underline
                      icon: Icon(Icons.arrow_drop_down),
                      items: dates.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 30,),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: ShapeDecoration(
                      shape: Theme.of(context).inputDecorationTheme.enabledBorder
                      is OutlineInputBorder
                          ? Theme.of(context).inputDecorationTheme.enabledBorder!
                      as OutlineInputBorder
                          : const OutlineInputBorder(),
                    ),
                    child: DropdownButton<String>(
                      value: selectedValue1,
                      isExpanded: true, // so it takes full width inside container
                      underline: SizedBox(), // removes default underline
                      icon: Icon(Icons.arrow_drop_down),
                      items: options.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue1 = newValue!;
                        });
                      },
                    ),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
