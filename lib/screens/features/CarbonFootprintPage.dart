import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CarbonFootprintPage extends StatefulWidget {
  @override
  _CarbonFootprintPageState createState() => _CarbonFootprintPageState();
}

class _CarbonFootprintPageState extends State<CarbonFootprintPage> {
  final Map<String, String> _answers = {
    'transport': 'Never',
    'electricity': 'Low',
    'waste': 'Minimal',
    'diet': 'Vegan',
    'shopping': 'Rarely',
    'recycling': 'Always',
    'appliances': 'Energy Efficient',
    'water': 'Low',
    'travel': 'Never',
    'home': 'Well Insulated',
  };

  double transportCarbon = 0.0;
  double energyCarbon = 0.0;
  double wasteCarbon = 0.0;
  double dietCarbon = 0.0;
  double shoppingCarbon = 0.0;
  double recyclingCarbon = 0.0;
  double appliancesCarbon = 0.0;
  double waterCarbon = 0.0;
  double travelCarbon = 0.0;
  double homeCarbon = 0.0;

  double totalCarbonFootprint = 0.0;

  void _updateCarbonFootprint() {
    setState(() {
      transportCarbon = {
        'Never': 0.0,
        'Occasionally': 100.0,
        'Regularly': 300.0,
        'Daily': 500.0,
      }[_answers['transport']]!;

      energyCarbon = {
        'Low': 100.0,
        'Average': 250.0,
        'High': 500.0,
      }[_answers['electricity']]!;

      wasteCarbon = {
        'Minimal': 50.0,
        'Moderate': 150.0,
        'High': 300.0,
      }[_answers['waste']]!;

      dietCarbon = {
        'Vegan': 50.0,
        'Vegetarian': 100.0,
        'Non-Vegetarian': 250.0,
      }[_answers['diet']]!;

      shoppingCarbon = {
        'Rarely': 50.0,
        'Sometimes': 150.0,
        'Frequently': 300.0,
      }[_answers['shopping']]!;

      recyclingCarbon = {
        'Always': 0.0,
        'Sometimes': 100.0,
        'Never': 200.0,
      }[_answers['recycling']]!;

      appliancesCarbon = {
        'Energy Efficient': 50.0,
        'Average': 150.0,
        'Old Appliances': 300.0,
      }[_answers['appliances']]!;

      waterCarbon = {
        'Low': 50.0,
        'Average': 150.0,
        'High': 300.0,
      }[_answers['water']]!;

      travelCarbon = {
        'Never': 0.0,
        'Occasionally': 200.0,
        'Frequently': 500.0,
      }[_answers['travel']]!;

      homeCarbon = {
        'Well Insulated': 50.0,
        'Poorly Insulated': 200.0,
        'Very Poor': 400.0,
      }[_answers['home']]!;

      totalCarbonFootprint = transportCarbon + energyCarbon + wasteCarbon +
          dietCarbon + shoppingCarbon + recyclingCarbon +
          appliancesCarbon + waterCarbon + travelCarbon + homeCarbon;
    });
  }

  List<PieChartSectionData> _createChartData() {
    return [
      PieChartSectionData(value: transportCarbon, color: Colors.blue.shade400, title: 'Transport', radius: 75, titleStyle: TextStyle(color: Colors.white)),
      PieChartSectionData(value: energyCarbon, color: Colors.green.shade400, title: 'Energy', radius: 75, titleStyle: TextStyle(color: Colors.white)),
      PieChartSectionData(value: wasteCarbon, color: Colors.orange.shade400, title: 'Waste', radius: 75, titleStyle: TextStyle(color: Colors.white)),
      PieChartSectionData(value: dietCarbon, color: Colors.purple.shade300, title: 'Diet', radius: 75, titleStyle: TextStyle(color: Colors.white)),
      PieChartSectionData(value: shoppingCarbon, color: Colors.pink.shade300, title: 'Shopping', radius: 75, titleStyle: TextStyle(color: Colors.white)),
      PieChartSectionData(value: recyclingCarbon, color: Colors.teal.shade300, title: 'Recycling', radius: 75, titleStyle: TextStyle(color: Colors.white)),
      PieChartSectionData(value: appliancesCarbon, color: Colors.brown.shade300, title: 'Appliances', radius: 75, titleStyle: TextStyle(color: Colors.white)),
      PieChartSectionData(value: waterCarbon, color: Colors.cyan.shade300, title: 'Water', radius: 75, titleStyle: TextStyle(color: Colors.white)),
      PieChartSectionData(value: travelCarbon, color: Colors.red.shade300, title: 'Travel', radius: 75, titleStyle: TextStyle(color: Colors.white)),
      PieChartSectionData(value: homeCarbon, color: Colors.indigo.shade300, title: 'Home', radius: 75, titleStyle: TextStyle(color: Colors.white)),
    ];
  }

  Widget _buildDropdown({
    required String label,
    required String fieldKey,
    required List<String> options,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        value: _answers[fieldKey],
        items: options
            .map((e) => DropdownMenuItem(child: Text(e), value: e))
            .toList(),
        onChanged: (val) => setState(() => _answers[fieldKey] = val!),
      ),
    );
  }

  String _getSuggestionMessage() {
    if (totalCarbonFootprint < 800) {
      return "✅ Keep up the great work! You can inspire others by sharing your eco-friendly habits.";
    } else if (totalCarbonFootprint < 1500) {
      return "♻️ Try using public transport, switching to a plant-based diet, and reducing shopping to lower your footprint.";
    } else {
      return "🔥 Your footprint is high. Focus on reducing energy use, limiting air travel, and embracing sustainable practices.";
    }
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
          Text("🌱 Estimate your carbon footprint by answering these questions:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),

          _buildDropdown(
            label: "🚗 How often do you use personal transport?",
            fieldKey: 'transport',
            options: ['Never', 'Occasionally', 'Regularly', 'Daily'],
          ),
          _buildDropdown(
            label: "💡 How much electricity do you consume?",
            fieldKey: 'electricity',
            options: ['Low', 'Average', 'High'],
          ),
          _buildDropdown(
            label: "🗑️ How much waste do you generate?",
            fieldKey: 'waste',
            options: ['Minimal', 'Moderate', 'High'],
          ),
          _buildDropdown(
            label: "🥦 What is your diet type?",
            fieldKey: 'diet',
            options: ['Vegan', 'Vegetarian', 'Non-Vegetarian'],
          ),
          _buildDropdown(
            label: "🛍️ How frequently do you shop?",
            fieldKey: 'shopping',
            options: ['Rarely', 'Sometimes', 'Frequently'],
          ),
          _buildDropdown(
            label: "♻️ Do you recycle?",
            fieldKey: 'recycling',
            options: ['Always', 'Sometimes', 'Never'],
          ),
          _buildDropdown(
            label: "🔌 Type of appliances you use?",
            fieldKey: 'appliances',
            options: ['Energy Efficient', 'Average', 'Old Appliances'],
          ),
          _buildDropdown(
            label: "🚿 Water consumption level?",
            fieldKey: 'water',
            options: ['Low', 'Average', 'High'],
          ),
          _buildDropdown(
            label: "✈️ How often do you travel by air?",
            fieldKey: 'travel',
            options: ['Never', 'Occasionally', 'Frequently'],
          ),
          _buildDropdown(
            label: "🏠 Home insulation quality?",
            fieldKey: 'home',
            options: ['Well Insulated', 'Poorly Insulated', 'Very Poor'],
          ),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: _updateCarbonFootprint,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue.shade400,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: Text(
              "Update Footprint",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 20),

          /// PIE CHART CARD
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text("📊 Carbon Footprint Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Container(
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        sections: _createChartData(),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 50,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${totalCarbonFootprint.toStringAsFixed(0)} kg CO₂ emitted",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          /// SUGGESTION CARD
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text("💡 Suggestions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text(
                    _getSuggestionMessage(),
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
