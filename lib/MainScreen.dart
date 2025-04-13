import 'package:flutter/material.dart';
import 'package:prakriti_svanrakshan/ProfilePage%20.dart';
import 'package:prakriti_svanrakshan/dashboard_screen.dart';
import 'AQIMapScreen.dart';
import 'CarbonFootprintPage.dart';
import 'HealthAnalysisPage.dart';
import 'TreesPlantedPage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(), // Home
    ProfilePage(),     // Profile
    AQIMapScreen(),    // Map
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
        ],
      ),
    );
  }
}
