import 'dart:io';
import 'package:flutter/material.dart';

class ImageAnalysisPage extends StatelessWidget {
  final File imageFile;

  const ImageAnalysisPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Analysis")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Detected Image", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                imageFile,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            _buildAnalysisSection(
              icon: Icons.warning_amber_rounded,
              title: "Pollution Type",
              content: "Solid Waste Pollution - visible accumulation of plastic, food containers, and mixed waste.",
            ),
            _buildAnalysisSection(
              icon: Icons.recycling,
              title: "Detected Waste Items",
              content: "Plastic bags, disposable cups, food wrappers, paper containers, mixed waste.",
            ),
            _buildAnalysisSection(
              icon: Icons.eco,
              title: "Environmental Impact",
              content:
                  "• Non-biodegradable plastics can persist for hundreds of years.\n"
                  "• Clogs drainage systems, attracting pests and spreading disease.\n"
                  "• Potential groundwater contamination through leachate.",
            ),
            _buildAnalysisSection(
              icon: Icons.lightbulb,
              title: "Suggested Actions",
              content:
                  "• Promote waste segregation at source.\n"
                  "• Avoid single-use plastics.\n"
                  "• Encourage recycling and composting.\n"
                  "• Report illegal dumping to local authorities.",
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.share),
                label: Text("Share Report"),
                onPressed: () {
                  // Future: implement sharing or saving feature
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.green.shade700),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(content, style: TextStyle(fontSize: 14, height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
