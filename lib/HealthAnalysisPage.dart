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

  String _activityLevel = "Moderate";
  String _dietType = "Balanced";
  double _waterIntake = 2.0;
  double _sleepHours = 7.0;

  void _calculateHealthMetrics() {
    double weight = double.tryParse(_weightController.text) ?? 0.0;
    double height = double.tryParse(_heightController.text) ?? 0.0;

    if (weight > 0 && height > 0) {
      setState(() {
        _bmi = weight / (height * height);
        _idealWeight = 22.0 * (height * height);
        _bmiHistory.add(FlSpot(_bmiHistory.length.toDouble(), _bmi));
      });
    }
  }

  LineChartData _generateChartData() {
    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 32,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text("Day ${value.toInt()}",
                    style: TextStyle(fontSize: 12)),
              );
            },
          ),
          axisNameWidget: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text("Check-in", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(value.toStringAsFixed(1),
                    style: TextStyle(fontSize: 12)),
              );
            },
          ),
          axisNameWidget: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text("BMI", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.shade300),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: _bmiHistory,
          isCurved: true,
          color: Colors.teal,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.teal.shade100.withOpacity(0.4),
          ),
        ),
      ],
      minX: 0,
      maxX: _bmiHistory.length > 0 ? _bmiHistory.length.toDouble() - 1 : 1,
    );
  }

  String _getLifestyleTip() {
    if (_sleepHours < 6) {
      return "Try to get more restful sleep. Aim for 7–9 hours for better recovery. 😴";
    } else if (_waterIntake < 1.5) {
      return "Hydration is key! Drink more water throughout the day. 💧";
    } else if (_activityLevel == "Sedentary") {
      return "Incorporate light activity into your day — even short walks help! 🏃‍♂️";
    } else if (_dietType == "Low Carb") {
      return "Make sure you're getting enough fiber and nutrients with your diet. 🌾";
    } else {
      return "You're on a solid path! Stay mindful and consistent. 💪";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🩺 Health Check-In"),
        backgroundColor: Colors.teal.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 4,
              color: Colors.teal.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text("Let's get to know you better",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    _buildInputField("🧍‍♂️ What's your weight in kilograms?", _weightController),
                    _buildInputField("📏 Your height in meters?", _heightController),
                    _buildInputField("🎂 How old are you?", _ageController),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _activityLevel,
                      items: ["Sedentary", "Moderate", "Active"]
                          .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                          .toList(),
                      onChanged: (value) => setState(() => _activityLevel = value!),
                      decoration: InputDecoration(
                        labelText: "🏃 Activity Level",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _dietType,
                      items: ["Balanced", "High Protein", "Low Carb", "Vegetarian", "Vegan"]
                          .map((diet) => DropdownMenuItem(value: diet, child: Text(diet)))
                          .toList(),
                      onChanged: (value) => setState(() => _dietType = value!),
                      decoration: InputDecoration(
                        labelText: "🥗 Diet Type",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text("🚰 Water Intake: ${_waterIntake.toStringAsFixed(1)} L"),
                    Slider(
                      min: 0.5,
                      max: 5.0,
                      divisions: 9,
                      value: _waterIntake,
                      label: "${_waterIntake.toStringAsFixed(1)} L",
                      onChanged: (value) => setState(() => _waterIntake = value),
                    ),
                    SizedBox(height: 12),
                    Text("🛌 Sleep Duration: ${_sleepHours.toStringAsFixed(1)} hrs"),
                    Slider(
                      min: 3,
                      max: 12,
                      divisions: 9,
                      value: _sleepHours,
                      label: "${_sleepHours.toStringAsFixed(1)} hrs",
                      onChanged: (value) => setState(() => _sleepHours = value),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _calculateHealthMetrics,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade400,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Show My Health Stats"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_bmi > 0)
              Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text("📋 Here's how you're doing!",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      Text("BMI: ${_bmi.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal.shade700)),
                      SizedBox(height: 12),
                      Text("Ideal Weight: ${_idealWeight.toStringAsFixed(2)} kg",
                          style: TextStyle(fontSize: 18, color: Colors.black87)),
                      SizedBox(height: 12),
                      Text(
                        _bmi < 18.5
                            ? "You're underweight. Let's work on gaining healthy mass. 💪"
                            : _bmi >= 25
                                ? "You’re in the overweight range. Consider more movement and balanced meals. 🥗🏃"
                                : "Perfect! You're in a healthy range. Keep shining! ✨",
                        style: TextStyle(
                          fontSize: 16,
                          color: _bmi < 18.5 || _bmi >= 25 ? Colors.redAccent : Colors.green.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),
            if (_bmiHistory.isNotEmpty) ...[
              Text("📈 Your BMI Progress", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(12),
                child: LineChart(_generateChartData()),
              ),
            ],
            SizedBox(height: 30),
            Card(
              elevation: 4,
              color: Colors.teal.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text("🧠 Smart Tips For You", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Text(
                      _getLifestyleTip(),
                      style: TextStyle(fontSize: 16),
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

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.fitness_center),
        ),
      ),
    );
  }
}
