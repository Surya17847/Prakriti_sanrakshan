import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Stack(
          fit: StackFit.expand,
          children: [
            //Full-Screen Image
            Image.asset(
              'assets/images/splash_screen.jpg',  // Ensure this image is in your assets folder
              fit: BoxFit.cover,
            ),
            
           
          ],
        
      ),
    );
  }
}
