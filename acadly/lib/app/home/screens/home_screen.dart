import 'package:acadly/app/auth/screens/activity.dart';
import 'package:acadly/app/auth/screens/notes.dart';
import 'package:acadly/app/auth/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:acadly/app/common/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage=0;
  List<Widget> pages = const [Notes(), Activity(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.accent,
          currentIndex: currentPage,
          onTap: (value){
            setState(() {
              currentPage=value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: "Notes",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.event),
                label: "Activity",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
            ),
          ]
      ),
    );
  }
}
