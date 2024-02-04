// ignore_for_file: unused_import

import 'dart:async';
import 'dart:convert';
import 'package:uum_career_advisor_app/views/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:uum_career_advisor_app/myconfig.dart';
import 'package:uum_career_advisor_app/views/screens/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'models/user.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //checkAndLogin();
    //loadPref();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (content) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/uum1crop.png'),
                    fit: BoxFit.cover))),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "UUM Career Advisor",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(),
              SizedBox(height: 40),
              Text(
                "Version 1.0",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),
        )
      ],
    ));
  }

/*
  checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    bool ischeck = (prefs.getBool('checkbox')) ?? false;
    late User user;
    if (ischeck) {
      try {
        http.post(
            Uri.parse("${MyConfig().SERVER}/uum_career_advisor_app/php/login_user.php"),
            body: {"email": email, "password": password}).then((response) {
          if (response.statusCode == 200) {
            var jsondata = jsonDecode(response.body);
            user = User.fromJson(jsondata['data']);
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (content) => MainScreen())));
          } else {
            user = User(
                id: "na",
                name: "na",
                email: "na",
                phone: "na",
                datereg: "na",
                password: "na",
                otp: "na");
            Timer(
                const Duration(seconds: 3),
                () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (content) => LoginScreen())));
          }
        }).timeout(const Duration(seconds: 5), onTimeout: () {
          // Time has run out, do what you wanted to do.
        });
      } on TimeoutException item (_) {
        print("Time out");
      }
    } else {
      user = User(
          id: "na",
          name: "na",
          email: "na",
          phone: "na",
          datereg: "na",
          password: "na",
          otp: "na");
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (content) => LoginScreen())));
    }
  }*/
}
