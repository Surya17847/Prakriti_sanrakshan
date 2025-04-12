import 'package:flutter/material.dart';
import 'package:prakriti_svanrakshan/AQIMapScreen.dart';
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
      Card(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 200,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Deforestation Impact", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Learn how tree loss affects biodiversity."),
            ],
          ),
        ),
      ),
      Card(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 200,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Green Energy Benefits", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Explore solar, wind and other clean energy."),
            ],
          ),
        ),
      ),
       Card(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 200,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Green Energy Benefits", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Explore solar, wind and other clean energy."),
            ],
          ),
        ),
      ),
       Card(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 200,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Green Energy Benefits", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("Explore solar, wind and other clean energy."),
            ],
          ),
        ),
      ),
      // Add more cards here
    ],
  ),
),


            // Personal Contribution Section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Personal Contribution", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          Container(
  height: 120,
  child: ListView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 12),
    children: [
      _buildContributionCard(
        icon: Icons.park,
        title: "Trees Planted",
        value: "10",
        color: Colors.green.shade100,
      ),
      _buildContributionCard(
        icon: Icons.eco,
        title: "Carbon Footprint",
        value: "Check",
        color: Colors.teal.shade100,
      ),
      _buildContributionCard(
        icon: Icons.report_problem,
        title: "Complaint Raised",
        value: "3",
        color: Colors.orange.shade100,
      ),
    ],
  ),
),


            // Map Section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Live AQI Map", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AQIMapScreen()),
    );
  },
  child: Container(
    height: 200,
    color: Colors.grey[300],
    child: Center(
      child: Text(
        "Live AQI Map Here",
        style: TextStyle(
          color: Colors.blueAccent,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
  ),
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
  Widget _buildContributionCard({
  required IconData icon,
  required String title,
  required String value,
  required Color color,
}) {
  return Card(
    color: color,
    margin: EdgeInsets.only(right: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      width: 180,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.black87),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    ),
  );
}

}
