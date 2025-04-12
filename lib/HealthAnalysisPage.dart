import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthAnalysisPage extends StatefulWidget {
  @override
  _HealthAnalysisPageState createState() => _HealthAnalysisPageState();
}

class _HealthAnalysisPageState extends State<HealthAnalysisPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  double _bmi = 0.0;
  double _idealWeight = 0.0;
  List<FlSpot> _bmiHistory = [];

  // Function to calculate BMI
  void _calculateHealthMetrics() {
    double weight = double.tryParse(_weightController.text) ?? 0.0;
    double height = double.tryParse(_heightController.text) ?? 0.0;

    if (weight > 0 && height > 0) {
      setState(() {
        // BMI formula
        _bmi = weight / (height * height);
        // Ideal weight formula (BMI range of 18.5 to 24.9)
        _idealWeight = 22.0 * (height * height);
        // Store BMI history for chart
        _bmiHistory.add(FlSpot(_bmiHistory.length.toDouble(), _bmi));
      });
    }
  }

  // Function to generate BMI progress chart
  LineChartData _generateChartData() {
    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(show: true),
      borderData: FlBorderData(show: true, border: Border.all(color: Colors.black26, width: 1)),
      lineBarsData: [
        LineChartBarData(
          spots: _bmiHistory,
          isCurved: true,
          color: Colors.blue,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Analysis"),
        backgroundColor: Colors.green.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Health Info Input Card
            Card(
              elevation: 4,
              color: Colors.green.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text("Enter Your Health Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    _buildInputField("Weight (kg)", _weightController),
                    _buildInputField("Height (m)", _heightController),
                    _buildInputField("Age (years)", _ageController),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _calculateHealthMetrics,
                      child: Text("Calculate BMI & Ideal Weight"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // BMI and Ideal Weight Display
            if (_bmi > 0)
              Card(
                elevation: 4,
                color: Colors.green.shade100,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text("Your Health Metrics", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      Text("BMI: ${_bmi.toStringAsFixed(2)}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      Text("Ideal Weight: ${_idealWeight.toStringAsFixed(2)} kg", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 12),
                      Text(
                        _bmi < 18.5
                            ? "Underweight"
                            : _bmi >= 25
                                ? "Overweight"
                                : "Normal Weight",
                        style: TextStyle(fontSize: 18, color: _bmi < 18.5 || _bmi >= 25 ? Colors.red : Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),

            // BMI Progress Chart
            Text("Your BMI Progress", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            if (_bmiHistory.isNotEmpty)
              Container(
                height: 300,
                child: LineChart(_generateChartData()),
              ),
            SizedBox(height: 20),

            // Recommendation Section
            Card(
              elevation: 4,
              color: Colors.green.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text("Health Recommendations", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Text(
                      _bmi < 18.5
                          ? "You are underweight. Consider eating more nutritious food and gain some weight."
                          : _bmi >= 25
                              ? "You are overweight. Regular exercise and a balanced diet can help."
                              : "Your weight is in the normal range. Keep up the good work and stay healthy!",
                      style: TextStyle(fontSize: 16, color: Colors.blue.shade700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

