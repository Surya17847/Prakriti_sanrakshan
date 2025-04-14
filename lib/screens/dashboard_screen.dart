import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prakriti_svanrakshan/screens/features/AQIMapScreen.dart';
import 'package:prakriti_svanrakshan/screens/features/CarbonFootprintPage.dart';
import 'package:prakriti_svanrakshan/screens/features/HealthAnalysisPage.dart';
import 'package:prakriti_svanrakshan/screens/features/ImageAnalysisPage.dart';
import 'package:prakriti_svanrakshan/screens/features/ProfilePage%20.dart';
import 'package:prakriti_svanrakshan/screens/features/TreesPlantedPage.dart';
import 'package:prakriti_svanrakshan/screens/features/news_api_service.dart';
import 'package:prakriti_svanrakshan/screens/features/news_article.dart';
import 'package:prakriti_svanrakshan/screens/features/trees_data.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text("Hi, Gaurav"),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile_image.jpg'),
          ),
          SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile_image.jpg'),
                    radius: 30,
                  ),
                  SizedBox(height: 10),
                  Text('Gaurav Gupta', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Profile'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Map'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AQIMapScreen())),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Add logout logic
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News Section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Latest Environmental News", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 220,
              child: FutureBuilder<List<NewsArticle>>(
                future: NewsApiService().fetchNewsArticles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Failed to load news'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No news found'));
                  } else {
                    final articles = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: articles.length,
                      itemBuilder: (context, index) => _buildNewsCard(articles[index]),
                    );
                  }
                },
              ),
            ),

            // Personal Contribution Section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Personal Contribution", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ),
            Container(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12),
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: TreeData.totalTreesPlanted,
                    builder: (context, value, _) {
                      return _buildContributionCard(
                        context: context,
                        icon: Icons.park,
                        title: "Trees Planted",
                        value: value.toString(),
                        color: Colors.green.shade100,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TreesPlantedPage())),
                      );
                    },
                  ),
                  _buildContributionCard(
                    context: context,
                    icon: Icons.eco,
                    title: "Carbon Footprint",
                    value: "Check",
                    color: Colors.teal.shade100,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CarbonFootprintPage())),
                  ),
                  _buildContributionCard(
                    context: context,
                    icon: Icons.monitor_heart,
                    title: "Health Analysis",
                    value: "Check",
                    color: Colors.orange.shade100,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HealthAnalysisPage())),
                  ),
                ],
              ),
            ),

            // Image Analysis Section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Image Analysis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.image, size: 40, color: Colors.green),
                          SizedBox(width: 16),
                          Expanded(child: Text("Upload an image for analysis", style: TextStyle(fontSize: 16))),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: Text("Upload"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_imageFile != null)
  GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageAnalysisPage(imageFile: _imageFile!),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Selected Image (Tap to Analyze):", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _imageFile!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    ),
  ),

                ],
              ),
            ),

            // Live AI Analysis Button
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Live AI Analysis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
  padding: EdgeInsets.symmetric(horizontal: 16),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.grey.shade200,
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          child: Container(
            height: 200,
            color: Colors.black12,
            child: Center(
              child: Icon(Icons.camera_alt, size: 60, color: Colors.grey),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Coming Soon: Real-Time AR Analysis",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                "Use your camera to detect environmental waste, classify pollution types, and get actionable insights instantly with AR overlays.",
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  // Placeholder for future AR feature
                },
                icon: Icon(Icons.camera),
                label: Text("Open Camera"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),         SizedBox(height: 20),
          ],
        ),
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
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black54),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(NewsArticle article) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Container(
        width: 240,
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article.urlToImage,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final uri = Uri.parse(article.url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
              child: Text(
                article.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 4),
            Flexible(
              child: Text(
                article.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
