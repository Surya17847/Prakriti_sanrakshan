import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CarbonFootprintPage extends StatefulWidget {
  @override
  _CarbonFootprintPageState createState() => _CarbonFootprintPageState();
}

class _CarbonFootprintPageState extends State<CarbonFootprintPage> {
  final TextEditingController _transportController = TextEditingController();
  final TextEditingController _energyController = TextEditingController();
  final TextEditingController _wasteController = TextEditingController();
  double totalCarbonFootprint = 0.0;
  double transportCarbon = 0.0;
  double energyCarbon = 0.0;
  double wasteCarbon = 0.0;

  // Function to calculate and update carbon footprint
  void _updateCarbonFootprint() {
    setState(() {
      transportCarbon = double.tryParse(_transportController.text) ?? 0.0;
      energyCarbon = double.tryParse(_energyController.text) ?? 0.0;
      wasteCarbon = double.tryParse(_wasteController.text) ?? 0.0;
      totalCarbonFootprint = transportCarbon + energyCarbon + wasteCarbon;
    });
  }

  // Data for the pie chart
  List<PieChartSectionData> _createChartData() {
    final List<PieChartSectionData> sections = [];

    if (transportCarbon > 0) {
      sections.add(PieChartSectionData(
        value: transportCarbon,
        color: Colors.blue.shade400,
        title: 'Transport: ${transportCarbon.toStringAsFixed(2)} kg',
        radius: 40,
        titleStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ));
    }
    if (energyCarbon > 0) {
      sections.add(PieChartSectionData(
        value: energyCarbon,
        color: Colors.green.shade400,
        title: 'Energy: ${energyCarbon.toStringAsFixed(2)} kg',
        radius: 40,
        titleStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ));
    }
    if (wasteCarbon > 0) {
      sections.add(PieChartSectionData(
        value: wasteCarbon,
        color: Colors.orange.shade400,
        title: 'Waste: ${wasteCarbon.toStringAsFixed(2)} kg',
        radius: 40,
        titleStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ));
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🌍 Carbon Footprint"),
        backgroundColor: Colors.blue.shade400,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Carbon Footprint Summary Card
          Card(
            elevation: 4,
            color: Colors.blue.shade100,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("Your Carbon Footprint 🌍", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text("$totalCarbonFootprint kg CO₂", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue.shade800)),
                  SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: totalCarbonFootprint / 1000,
                    minHeight: 10,
                    backgroundColor: Colors.blue.shade50,
                    color: Colors.blue.shade600,
                  ),
                  SizedBox(height: 8),
                  Text("Your Goal: Reduce to 1000 kg CO₂"),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Carbon Footprint Input Fields
          Text("Enter your Carbon Footprint for different activities", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          _buildInputField("Transport (kg CO₂)", _transportController),
          _buildInputField("Energy Usage (kg CO₂)", _energyController),
          _buildInputField("Waste (kg CO₂)", _wasteController),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _updateCarbonFootprint,
            child: Text("Update Footprint"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600),
          ),
          SizedBox(height: 20),

          // Carbon Footprint Pie Chart
          Text("Carbon Footprint Breakdown", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Container(
            height: 300,
            padding: EdgeInsets.all(10),
            child: PieChart(
              PieChartData(
                sections: _createChartData(),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Input Field Widget
  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

