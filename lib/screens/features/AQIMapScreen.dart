import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AQIMapScreen extends StatefulWidget {
  const AQIMapScreen({super.key});

  @override
  State<AQIMapScreen> createState() => _AQIMapScreenState();
}

class _AQIMapScreenState extends State<AQIMapScreen> {
  List<Marker> markers = [];
  Map<String, dynamic> selectedComponents = {};
  String selectedCity = '';
  TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> sampleLocations = [
    {'city': 'Mumbai', 'lat': 19.0760, 'lon': 72.8777},
    {'city': 'Delhi', 'lat': 28.6139, 'lon': 77.2090},
    {'city': 'Bangalore', 'lat': 12.9716, 'lon': 77.5946},
    {'city': 'Hyderabad', 'lat': 17.3850, 'lon': 78.4867},
    {'city': 'Chennai', 'lat': 13.0827, 'lon': 80.2707},
  ];

  @override
  void initState() {
    super.initState();
    fetchAllMarkers();
  }

  Future<void> fetchAllMarkers() async {
    List<Marker> loadedMarkers = [];
    for (var location in sampleLocations) {
      final aqiData = await fetchAQIData(location['lat'], location['lon']);
      if (aqiData != null) {
        final aqi = aqiData['main']['aqi'];
        loadedMarkers.add(
          Marker(
            point: LatLng(location['lat'], location['lon']),
            width: 40,
            height: 40,
            child: Icon(Icons.location_on, size: 35, color: getAQIColor(aqi)),
          ),
        );
      }
    }
    setState(() {
      markers = loadedMarkers;
    });
  }

  Future<Map<String, dynamic>?> fetchAQIData(double lat, double lon) async {
    final url =
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=799bebff1ae2f74cda8f9319be841622';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['list'][0];
    } else {
      return null;
    }
  }

  void onCitySelected(String city) async {
    final selected = sampleLocations.firstWhere((e) => e['city'] == city);
    final aqiData = await fetchAQIData(selected['lat'], selected['lon']);

    if (aqiData != null) {
      setState(() {
        selectedComponents = aqiData['components'];
        selectedCity = city;
      });
    }
  }

  Color getAQIColor(int aqi) {
    if (aqi == 1) return Colors.green;
    if (aqi == 2) return Colors.yellow;
    if (aqi == 3) return Colors.orange;
    if (aqi == 4) return Colors.red;
    if (aqi == 5) return Colors.purple;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(21.1458, 79.0882), // Central India
              initialZoom: 5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 45,
                  size: const Size(40, 40),
                  markers: markers,
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          '${markers.length}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return const Iterable<String>.empty();
                            }
                            return sampleLocations
                                .map((e) => e['city'].toString())
                                .where((option) => option
                                    .toLowerCase()
                                    .contains(textEditingValue.text.toLowerCase()));
                          },
                          onSelected: (String city) => onCitySelected(city),
                          fieldViewBuilder: (context, controller, focusNode, _) {
                            searchController = controller;
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: const InputDecoration(
                                hintText: 'Search city...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10),
                              ),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          String city = searchController.text.trim();
                          if (city.isNotEmpty) {
                            onCitySelected(city);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bottom Card
          DraggableScrollableSheet(
            initialChildSize: 0.12,
            minChildSize: 0.12,
            maxChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    if (selectedComponents.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            "Select a city to view AQI details",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                    else ...[
                      Text(
                        'Air Quality in $selectedCity',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        child: AQIPieChart(components: selectedComponents),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: selectedComponents.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(entry.key.toUpperCase(),
                                    style: const TextStyle(fontSize: 14)),
                                Text('${entry.value.toStringAsFixed(1)} µg/m³',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AQIPieChart extends StatelessWidget {
  final Map<String, dynamic> components;

  const AQIPieChart({super.key, required this.components});

  @override
  Widget build(BuildContext context) {
    if (components.isEmpty) {
      return const Center(child: Text("No data to show"));
    }

    final values = {
      'PM2.5': components['pm2_5'] ?? 0.0,
      'PM10': components['pm10'] ?? 0.0,
      'NO2': components['no2'] ?? 0.0,
      'SO2': components['so2'] ?? 0.0,
      'O3': components['o3'] ?? 0.0,
    };

    return PieChart(
      PieChartData(
        sections: values.entries.map((entry) {
          final color = _getColor(entry.key);
          return PieChartSectionData(
            color: color,
            value: entry.value.toDouble(),
            title: '${entry.key}\n${entry.value.toStringAsFixed(1)}',
            radius: 40,
            titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 30,
        startDegreeOffset: -90,
      ),
    );
  }

  Color _getColor(String key) {
    switch (key) {
      case 'PM2.5':
        return Colors.green;
      case 'PM10':
        return Colors.orange;
      case 'NO2':
        return Colors.red;
      case 'SO2':
        return Colors.purple;
      case 'O3':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
