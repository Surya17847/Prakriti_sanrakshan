import 'package:flutter/material.dart';
import 'package:prakriti_svanrakshan/AQIMapScreen.dart';
import 'package:prakriti_svanrakshan/CarbonFootprintPage.dart';
import 'package:prakriti_svanrakshan/HealthAnalysisPage.dart';
import 'package:prakriti_svanrakshan/TreesPlantedPage.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'news_card.dart';
// import 'personal_contribution_card.dart';
// import 'image_analysis_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu), // Menu icon
        title: Text("Hi, Gaurav"),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile_image.jpg'), // Profile image
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
  height: 180, // Adjusted height for better layout
  child: ListView(
    scrollDirection: Axis.horizontal,
    children: [
      // Card 1: Deforestation Impact
      Card(
        margin: EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Container(
          width: 200,
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://example.com/deforestation_image.jpg', // Replace with actual image URL
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Deforestation Impact",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                "Learn how tree loss affects biodiversity.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Open the link to the news website
                  // launchURL('https://example.com/deforestation-news');
                },
                child: Text('Read More'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
      ),

      // Card 2: Green Energy Benefits
      Card(
        margin: EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Container(
          width: 200,
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://example.com/green_energy_image.jpg', // Replace with actual image URL
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Green Energy Benefits",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                "Explore solar, wind, and other clean energy.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Open the link to the news website
                  // launchURL('https://example.com/green-energy-news');
                },
                child: Text('Read More'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              ),
            ],
          ),
        ),
      ),

      // Card 3: Add another card following the same structure
      Card(
        margin: EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Container(
          width: 200,
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://example.com/clean_energy_image.jpg', // Replace with actual image URL
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Clean Energy Innovations",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                "Stay updated with the latest in clean energy technology.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Open the link to the news website
                  // launchURL('https://example.com/clean-energy-news');
                },
                child: Text('Read More'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
),

// Function to open the URL



            // Personal Contribution Section
           Padding(
  padding: EdgeInsets.all(16.0),
  child: Text(
    "Personal Contribution",
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  ),
),
Container(
  height: 140,
  child: ListView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 12),
    children: [
      _buildContributionCard(
        context: context,
        icon: Icons.park,
        title: "Trees Planted",
        value: "10",
        color: Colors.green.shade100,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TreesPlantedPage()),
          );
        },
      ),
      _buildContributionCard(
        context: context,
        icon: Icons.eco,
        title: "Carbon Footprint",
        value: "Check",
        color: Colors.teal.shade100,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CarbonFootprintPage()),
          );
        },
      ),
      _buildContributionCard(
        context: context,
        icon: Icons.monitor_heart,
        title: "Health Analysis",
        value: "5 hrs",
        color: Colors.orange.shade100,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HealthAnalysisPage()),
          );
        },
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
  required BuildContext context,
  required IconData icon,
  required String title,
  required String value,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 160,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.black54),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}



}
// void launchURL(String url) async {
//   final Uri uri = Uri.parse(url);
//   if (await canLaunchUrl(uri)) {
//     await launchUrl(uri, mode: LaunchMode.externalApplication);
//   } else {
//     throw 'Could not launch $url';
//   }
// }
