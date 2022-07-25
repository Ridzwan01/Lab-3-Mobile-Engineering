import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_tutor/views/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'myTutor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MySplashScreen(title: 'Flutter Demo Home Page')
    );
  }
}

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key, required String title}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  
  @override
  void initState(){
    super.initState();
    Timer(
      const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => login()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/MyTutor.jpg'),
                fit: BoxFit.cover,
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const[
                Text('', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                CircularProgressIndicator(),
                Text('Virsion 0.1', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
              ],
            ),
          )
        ],
        )
    );
  }
}