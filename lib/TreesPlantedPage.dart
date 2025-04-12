import 'package:flutter/material.dart';

class TreesPlantedPage extends StatefulWidget {
  @override
  _TreesPlantedPageState createState() => _TreesPlantedPageState();
}

class _TreesPlantedPageState extends State<TreesPlantedPage> {
  int totalTreesPlanted = 10;  // Starting value
  final int monthlyGoal = 20;   // Monthly goal
  final TextEditingController _controller = TextEditingController();

  // Function to update trees planted based on user input
  void _addTrees() {
    setState(() {
      int treesToAdd = int.tryParse(_controller.text) ?? 0;  // Default to 0 if input is not a valid number
      if (treesToAdd > 0) {
        totalTreesPlanted += treesToAdd;
      }
      _controller.clear();  // Clear the input field after submitting
    });
  }

  @override
  Widget build(BuildContext context) {
    double progressPercent = totalTreesPlanted / monthlyGoal;

    return Scaffold(
      appBar: AppBar(
        title: Text("🌱 Trees Planted"),
        backgroundColor: Colors.green.shade400,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Summary Card
          Card(
            elevation: 4,
            color: Colors.green.shade100,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("Your Tree Contribution 🌳", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text("$totalTreesPlanted Trees Planted", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green.shade800)),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progressPercent,
                    minHeight: 10,
                    backgroundColor: Colors.green.shade50,
                    color: Colors.green.shade600,
                  ),
                  SizedBox(height: 8),
                  Text("Monthly Goal: $monthlyGoal Trees"),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Activity History Section
          Text("🌿 Recent Activity", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          _buildActivityCard("Planted 3 trees at City Park", "April 12, 2025"),
          _buildActivityCard("Planted 5 trees near Lake View", "April 9, 2025"),
          _buildActivityCard("Planted 2 trees in Backyard", "April 5, 2025"),
          SizedBox(height: 20),

          // Add New Tree Plantation Section
          Card(
            elevation: 4,
            color: Colors.lightGreen.shade50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Add New Plantation 🌱", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter number of trees",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _addTrees,
                    child: Text("Add Trees"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Recent Activity Card
  Widget _buildActivityCard(String description, String date) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.park, color: Colors.green, size: 30),
        title: Text(description, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        subtitle: Text(date),
      ),
    );
  }
}
