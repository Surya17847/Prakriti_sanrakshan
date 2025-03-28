import 'package:flutter/material.dart';
// import 'news_card.dart';
// import 'personal_contribution_card.dart';
// import 'image_analysis_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu), // Menu icon
        title: Text("Hi, Alexander"),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile.jpg'), // Profile image
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News Section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("News", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 150, // Fixed height for horizontal scrolling
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // NewsCard(image: 'assets/news1.jpg', title: "Deforestation Impact"),
                  // NewsCard(image: 'assets/news2.jpg', title: "Green Energy Benefits"),
                ],
              ),
            ),

            // Personal Contribution Section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Personal Contribution", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 120, // Fixed height for horizontal cards
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // PersonalContributionCard(title: "Trees Planted", value: "10"),
                  // PersonalContributionCard(title: "Carbon Footprint", value: "Check"),
                ],
              ),
            ),

            // Map Section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Live AQI Map", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 200, // Placeholder for map
              color: Colors.grey[300],
              child: Center(child: Text("Live AQI Map Here")),
            ),

            // Image Analysis Section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Image Analysis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                leading: Icon(Icons.image, size: 40),
                title: Text("Upload Image"),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ImageAnalysisScreen()),
                    // );
                  },
                  child: Text("Upload"),
                ),
              ),
            ),

            // Live AI Analysis (AR)
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Live AI Analysis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to AR Screen
                },
                icon: Icon(Icons.camera),
                label: Text("Open Camera"),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
        ],
      ),
    );
  }
}
