import 'package:flutter/material.dart';
import 'package:prakriti_svanrakshan/screens/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prakriti_svanrakshan/screens/MainScreen.dart';  // Import the HomeScreen
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Enable Firestore offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prakriti Sanrakshan',
       debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), // Listen for auth state changes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while waiting for authentication state
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            // If user is logged in, go to HomeScreen
            return MainScreen();
          } else {
            // If user is not logged in, go to SplashScreen
            return SplashScreen();
          }
        },
      ),

    );
  }
}


// home: StreamBuilder<User?>(
// stream: FirebaseAuth.instance.authStateChanges(), // Listen for authentication state changes
// builder: (context, snapshot) {
// if (snapshot.connectionState == ConnectionState.waiting) {
// return const Center(child: CircularProgressIndicator());
// }
// if (snapshot.hasData) {
// // If user is logged in, check if instructions are already seen
// return const HomeScreen(); // Directly go to HomeScreen if the user is logged in
// } else {
// // If user is not logged in, show InstructionsSlider
// return const SplashScreen();
// }
// },
// ),

