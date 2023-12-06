import 'package:flutter/material.dart';
import 'package:saggichatapp/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Preferences.dart';
import '../auth/register.dart';
import '../dashboard/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = true;

  @override
  void initState() {
    super.initState();

    checkLoginStatus();
  }

  // var isLoggedIn;

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await Preferences.getUserId();
    print('User ID retrieved: $userId');
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User is logged in, navigate to homepage
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => homeScreen()));
    } else {
      // User is not logged in, navigate to login screen
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => RegisterPage()));
    }
  }

  // Future<void> hideScreen() async {
  //   // Simulate some initialization tasks here if needed
  //
  //   // Delay for 3 seconds (3000 milliseconds) before hiding the splash screen
  //   await Future.delayed(Duration(milliseconds: 3000));
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context)=> isLoggedIn ? homeScreen() : LoginPage(),));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png'),
              Text(
                "Saggi Chat",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }
}
