import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_tutor/views/subject.dart';
import 'package:my_tutor/views/tutor.dart';
import 'package:my_tutor/views/mainscreen.dart';
import 'package:http/http.dart' as http;
import '../models/subjects.dart';

class mainScreen extends StatefulWidget {

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  int currentIndex = 0;
  List screens = [
    subjectScreen(),
    tutorScreen(),
    Center(child: Text('Subcribe')),
    Center(child: Text('favorite')),
    Center(child: Text('profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

  body: screens[currentIndex],

  bottomNavigationBar: BottomNavigationBar(

    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.cyan,
    selectedItemColor: Colors.white,
    currentIndex: currentIndex,
    onTap: (index) => setState(() => currentIndex = index), 

    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: 'Subjects',
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: 'Tutors',
      ),
      
      BottomNavigationBarItem(
        icon: Icon(Icons.money),
        label: 'Subcribe',
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Favourite',
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
  ),

    );
  }
}