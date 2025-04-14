import 'package:flutter/material.dart';
import 'package:prakriti_svanrakshan/AQIMapScreen.dart';
import 'package:prakriti_svanrakshan/CarbonFootprintPage.dart';
import 'package:prakriti_svanrakshan/HealthAnalysisPage.dart';
import 'package:prakriti_svanrakshan/ProfilePage%20.dart';
import 'package:prakriti_svanrakshan/TreesPlantedPage.dart';
import 'package:prakriti_svanrakshan/news_api_service.dart';
import 'package:prakriti_svanrakshan/news_article.dart';
import 'package:prakriti_svanrakshan/trees_data.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatelessWidget {
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
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile_image.jpg'),
                    radius: 30,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Gaurav Gupta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Profile'),
              onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Map'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AQIMapScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Logout logic
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
  child: Text("Latest Environmental News",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
),
Container(
  height: 220,
  child: FutureBuilder<List<NewsArticle>>(
    
future: (() {
    print("Calling fetchNewsArticles()");
    return NewsApiService().fetchNewsArticles();
  })(),    builder: (context, snapshot) {
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
          itemBuilder: (context, index) {
            final article = articles[index];
            return _buildNewsCard(article);
          },
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TreesPlantedPage()),
        );
      },
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CarbonFootprintPage()));
                    },
                  ),
                  _buildContributionCard(
                    context: context,
                    icon: Icons.monitor_heart,
                    title: "Health Analysis",
                    value: "5 hrs",
                    color: Colors.orange.shade100,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HealthAnalysisPage()));
                    },
                  ),
                ],
              ),
            ),

            // Live AQI Map Section
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Live AQI Map", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AQIMapScreen()));
              },
              child: Container(
                height: 200,
                color: Colors.grey[300],
                margin: EdgeInsets.symmetric(horizontal: 16),
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
                    // Implement Image Analysis Navigation
                  },
                  child: Text("Upload"),
                ),
              ),
            ),

            // Live AI Analysis
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Live AI Analysis", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Implement Camera Navigation
                },
                icon: Icon(Icons.camera),
                label: Text("Open Camera"),
              ),
            ),

            SizedBox(height: 20),
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
          // Image
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

          // Clickable Title
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

          // Description with flexible space to avoid overflow
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
