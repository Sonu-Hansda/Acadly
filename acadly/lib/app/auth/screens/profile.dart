import 'package:acadly/utils/variable.dart';
import 'package:flutter/material.dart';
import '../../common/theme/colors.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(color: AppColors.accent),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50,),
                CircleAvatar(
                  radius: 80,
                  backgroundImage:  AssetImage(
                    (person[0]['photoURL'] != null && (person[0]['photoURL'] as String).isNotEmpty)
                        ? person[0]['photoURL'] as String
                        : 'assets/img.png',
                  ),
                ),
                SizedBox(height: 75,),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: ShapeDecoration(
                      shape: (Theme.of(context).inputDecorationTheme.enabledBorder as OutlineInputBorder?)?.borderSide != null
                          ? (Theme.of(context).inputDecorationTheme.enabledBorder as OutlineInputBorder)
                          : const OutlineInputBorder(),
                  ),
                  width: double.maxFinite,
                  child: Text(person[0]['Username'] as String),
                ),
                SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: ShapeDecoration(
                    shape: (Theme.of(context).inputDecorationTheme.enabledBorder as OutlineInputBorder?)?.borderSide != null
                        ? (Theme.of(context).inputDecorationTheme.enabledBorder as OutlineInputBorder)
                        : const OutlineInputBorder(),
                  ),
                  width: double.maxFinite,
                  child: Text(person[0]['Regno'] as String),
                ),
                SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: ShapeDecoration(
                    shape: (Theme.of(context).inputDecorationTheme.enabledBorder as OutlineInputBorder?)?.borderSide != null
                        ? (Theme.of(context).inputDecorationTheme.enabledBorder as OutlineInputBorder)
                        : const OutlineInputBorder(),
                  ),
                  width: double.maxFinite,
                  child: Text(person[0]['branch'] as String),
                ),
                SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: ShapeDecoration(
                    shape: (Theme.of(context).inputDecorationTheme.enabledBorder as OutlineInputBorder?)?.borderSide != null
                        ? (Theme.of(context).inputDecorationTheme.enabledBorder as OutlineInputBorder)
                        : const OutlineInputBorder(),
                  ),
                  width: double.maxFinite,
                  child: Text('Change Password'),
                ),
                SizedBox(height: 30,),
                Text('PrivacyPolicy'),
                SizedBox(height: 10,),
                Text('Contact')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
