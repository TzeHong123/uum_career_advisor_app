//import 'package:uum_career_advisor_app/views/screens/OfferTab/Offertabscreen.dart';
import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/views/screens/ProfileTab/profiletabscreen.dart';
import 'package:uum_career_advisor_app/views/screens/JobTab/Jobtabscreen.dart';

import '../../models/user.dart';
import 'AdviceTab/Advicetabscreen.dart';
import 'QuestionTab/Questiontabscreen.dart';

//Main screen

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Job Details";

  @override
  void initState() {
    super.initState();
    print(widget.user.name);
    print("Mainscreen");
    tabchildren = [
      // OfferTabScreen(
      //   user: widget.user,
      // ),
      JobTabScreen(user: widget.user),
      AdviceTabScreen(user: widget.user),
      QuestionTabScreen(user: widget.user),
      ProfileTabScreen(user: widget.user),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            // BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.inventory,
            //     ),
            //     label: "Inventory"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
                label: "Job Detail"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.question_answer,
                ),
                label: "Advice"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.question_answer,
                ),
                label: "Q&A"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Job Information";
      }
      if (_currentIndex == 1) {
        maintitle = "Advice";
      }
      if (_currentIndex == 2) {
        maintitle = "Q&A";
      }
      if (_currentIndex == 3) {
        maintitle = "Profile";
      }
    });
  }
}
