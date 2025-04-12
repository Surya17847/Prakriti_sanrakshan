import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AQI Map India',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const AQIMapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AQIMapScreen extends StatefulWidget {
  const AQIMapScreen({super.key});
  @override
  _AQIMapScreenState createState() => _AQIMapScreenState();
}

class _AQIMapScreenState extends State<AQIMapScreen> {
  final _searchController = TextEditingController();
  final _mapController    = MapController();
  final List<Marker> _markers = [];
  final String _apiKey    = 'YOUR_OPENWEATHERMAP_API_KEY'; // ← replace this

  Map<String, dynamic>? _selectedData;

  // State & UT capitals
  final List<Map<String, dynamic>> _stateCapitals = [
    {'name':'Andhra Pradesh (Amaravati)','lat':16.5417,'lon':80.5150},
    {'name':'Arunachal Pradesh (Itanagar)','lat':27.0844,'lon':93.6053},
    {'name':'Assam (Dispur)','lat':26.1433,'lon':91.7898},
    {'name':'Bihar (Patna)','lat':25.5941,'lon':85.1376},
    {'name':'Chhattisgarh (Raipur)','lat':21.2514,'lon':81.6296},
    {'name':'Goa (Panaji)','lat':15.4909,'lon':73.8278},
    {'name':'Gujarat (Gandhinagar)','lat':23.2156,'lon':72.6369},
    {'name':'Haryana (Chandigarh)','lat':30.7333,'lon':76.7794},
    {'name':'Himachal Pradesh (Shimla)','lat':31.1048,'lon':77.1734},
    {'name':'Jharkhand (Ranchi)','lat':23.3441,'lon':85.3096},
    {'name':'Karnataka (Bengaluru)','lat':12.9716,'lon':77.5946},
    {'name':'Kerala (Thiruvananthapuram)','lat':8.5241,'lon':76.9366},
    {'name':'Madhya Pradesh (Bhopal)','lat':23.2599,'lon':77.4126},
    {'name':'Maharashtra (Mumbai)','lat':19.0760,'lon':72.8777},
    {'name':'Manipur (Imphal)','lat':24.8170,'lon':93.9368},
    {'name':'Meghalaya (Shillong)','lat':25.5788,'lon':91.8933},
    {'name':'Mizoram (Aizawl)','lat':23.7271,'lon':92.7176},
    {'name':'Nagaland (Kohima)','lat':25.6740,'lon':94.1100},
    {'name':'Odisha (Bhubaneswar)','lat':20.2961,'lon':85.8245},
    {'name':'Punjab (Chandigarh)','lat':30.7333,'lon':76.7794},
    {'name':'Rajasthan (Jaipur)','lat':26.9124,'lon':75.7873},
    {'name':'Sikkim (Gangtok)','lat':27.3314,'lon':88.6130},
    {'name':'Tamil Nadu (Chennai)','lat':13.0827,'lon':80.2707},
    {'name':'Telangana (Hyderabad)','lat':17.3850,'lon':78.4867},
    {'name':'Tripura (Agartala)','lat':23.8315,'lon':91.2868},
    {'name':'Uttar Pradesh (Lucknow)','lat':26.8467,'lon':80.9462},
    {'name':'Uttarakhand (Dehradun)','lat':30.3165,'lon':78.0322},
    {'name':'West Bengal (Kolkata)','lat':22.5726,'lon':88.3639},
    // UTs
    {'name':'Andaman & Nicobar (Port Blair)','lat':11.6667,'lon':92.7500},
    {'name':'Chandigarh','lat':30.7333,'lon':76.7794},
    {'name':'Dadra & Nagar Haveli','lat':20.1809,'lon':73.0169},
    {'name':'Daman & Diu','lat':20.4283,'lon':72.8397},
    {'name':'Delhi','lat':28.6139,'lon':77.2090},
    {'name':'Jammu & Kashmir (Srinagar)','lat':34.0837,'lon':74.7973},
    {'name':'Ladakh (Leh)','lat':34.1526,'lon':77.5770},
    {'name':'Lakshadweep (Kavaratti)','lat':10.5623,'lon':72.6369},
    {'name':'Puducherry','lat':11.9416,'lon':79.8083},
  ];

  @override
  void initState() {
    super.initState();
    _loadStateCapitalsMarkers();
  }

  Future<void> _loadStateCapitalsMarkers() async {
    for (var city in _stateCapitals) {
      await _fetchAndAddAQIMarker(
        city['lat'] as double,
        city['lon'] as double,
        city['name'] as String,
      );
    }
  }

  Future<void> _fetchAndAddAQIMarker(
    double lat,
    double lon,
    String label,
  ) async {
    final url =
      'https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$_apiKey';
    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) return;

    final data = jsonDecode(resp.body);
    final comps = Map<String, dynamic>.from(data['list'][0]['components']);
    final aqiValue = _calculateAQI(comps);

    final marker = Marker(
      point: LatLng(lat, lon),
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () => _onMarkerTap(label, aqiValue, comps, LatLng(lat, lon)),
        child: Icon(
          Icons.location_on,
          color: _getAQIColor(aqiValue),
          size:  30,
        ),
      ),
    );

    setState(() => _markers.add(marker));
  }

  /// Calculates overall AQI (0–500) from PM2.5 & PM10
  int _calculateAQI(Map<String, dynamic> c) {
    double pm25 = (c['pm2_5'] as num).toDouble();
    double pm10 = (c['pm10']  as num).toDouble();
    final aqi25 = _calcIndividualAQI(pm25, _pm25Break);
    final aqi10 = _calcIndividualAQI(pm10, _pm10Break);
    return max(aqi25, aqi10).round();
  }

  int _calcIndividualAQI(double conc, List<List<double>> bp) {
    for (var b in bp) {
      final Clow = b[0], Chigh = b[1], Ilow = b[2], Ihigh = b[3];
      if (conc >= Clow && conc <= Chigh) {
        return (((Ihigh - Ilow)/(Chigh - Clow))*(conc - Clow) + Ilow).round();
      }
    }
    return 500;
  }

  static const List<List<double>> _pm25Break = [
    [0.0,12.0,0,50], [12.1,35.4,51,100], [35.5,55.4,101,150],
    [55.5,150.4,151,200], [150.5,250.4,201,300],
    [250.5,350.4,301,400], [350.5,500.4,401,500],
  ];
  static const List<List<double>> _pm10Break = [
    [0,54,0,50], [55,154,51,100], [155,254,101,150],
    [255,354,151,200], [355,424,201,300],
    [425,504,301,400], [505,604,401,500],
  ];

  Color _getAQIColor(int aqi) {
    if (aqi <= 50)  return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.brown;
  }

  void _onMarkerTap(
    String label,
    int aqi,
    Map<String, dynamic> comps,
    LatLng pos,
  ) {
    _mapController.move(pos, 7.0);
    setState(() {
      _selectedData = {
        'label': label,
        'aqi': aqi,
        'components': comps,
      };
    });
    _showBottomSheet();
  }

  Future<List<Map<String, dynamic>>> _fetchSuggestions(String q) async {
    if (q.length < 2) return [];
    final url =
      'https://nominatim.openstreetmap.org/search?q=$q,India&format=json&limit=5';
    final resp = await http.get(Uri.parse(url), headers: {
      'User-Agent': 'flutter_map_app'
    });
    if (resp.statusCode != 200) return [];
    final List data = jsonDecode(resp.body);
    return data.map((e) => {
      'display_name': e['display_name'],
      'lat': double.parse(e['lat']),
      'lon': double.parse(e['lon']),
    }).toList();
  }

  void _onSuggestionSelected(Map<String, dynamic> s) {
    final lat = s['lat'] as double;
    final lon = s['lon'] as double;
    final name = (s['display_name'] as String).split(',')[0];
    _searchController.text = name;
    _fetchAndAddAQIMarker(lat, lon, name);
    _mapController.move(LatLng(lat, lon), 10.0);
  }

  void _showBottomSheet() {
    if (_selectedData == null) return;

    final label = _selectedData!['label'] as String;
    final aqi   = _selectedData!['aqi']   as int;
    final comps = _selectedData!['components'] as Map<String, dynamic>;
    final keys  = comps.keys.toList();
    final vals  = keys.map((k) => (comps[k] as num).toDouble()).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.85,
        builder: (context, ctrl) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: ListView(
              controller: ctrl,
              padding: EdgeInsets.all(16),
              children: [
                Center(
                  child: Container(
                    width: 40, height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(label,
                  style: TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
                SizedBox(height: 6),
                Text('AQI: $aqi  (${_getAQIDesc(aqi)})',
                  style: TextStyle(
                    fontSize:16,
                    color: _getAQIColor(aqi),
                    fontWeight: FontWeight.w600,
                  )),
                SizedBox(height: 8),
                Text(_getHealthRec(aqi),
                  style: TextStyle(fontSize:14)),
                SizedBox(height:16),

                // Pie Chart
                SizedBox(
                  height:200,
                  child: PieChart(PieChartData(
                    sections: List.generate(keys.length,(i){
                      return PieChartSectionData(
                        value: vals[i],
                        title: keys[i],
                        radius:50,
                        titleStyle: TextStyle(fontSize:10),
                        color: Colors.primaries[i % Colors.primaries.length],
                      );
                    }),
                  )),
                ),

                SizedBox(height:16),
                // Bar Chart
                SizedBox(
                  height:200,
                  child: BarChart(BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: vals.reduce((a,b)=>a>b?a:b)*1.2,
                    barGroups: List.generate(keys.length,(i){
                      return BarChartGroupData(
                        x: i,
                        barRods: [BarChartRodData(
                          toY: vals[i],
                          width:16,
                          color: Colors.primaries[i % Colors.primaries.length],
                        )],
                      );
                    }),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles:true,
                          getTitlesWidget:(v,_)=>Text(
                            keys[v.toInt()],
                            style:TextStyle(fontSize:10),
                          ),
                        ),
                      ),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles:false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles:false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles:false)),
                    ),
                    borderData: FlBorderData(show:false),
                    gridData: FlGridData(show:false),
                  )),
                ),

                SizedBox(height:16),
                // Numeric pollutant list
                ...List.generate(keys.length,(i) {
                  return ListTile(
                    dense: true,
                    title: Text(keys[i].toUpperCase()),
                    trailing: Text('${vals[i].toStringAsFixed(1)} µg/m³'),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getAQIDesc(int aqi) {
    if (aqi <= 50)  return "Good";
    if (aqi <= 100) return "Moderate";
    if (aqi <= 150) return "Unhealthy for SG";
    if (aqi <= 200) return "Unhealthy";
    if (aqi <= 300) return "Very Unhealthy";
    return "Hazardous";
  }

  String _getHealthRec(int aqi) {
    if (aqi <= 50)  return "Air quality is satisfactory.";
    if (aqi <= 100) return "Acceptable for most people.";
    if (aqi <= 150) return "Sensitive groups should reduce prolonged outdoor exertion.";
    if (aqi <= 200) return "Everyone may begin to experience health effects.";
    if (aqi <= 300) return "Health alert: more serious health effects.";
    return "Health warnings of emergency conditions.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TypeAheadField<Map<String, dynamic>>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search India…',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal:12, vertical:8),
              ),
            ),
            suggestionsCallback: _fetchSuggestions,
            itemBuilder: (ctx, s) {
              final name = (s['display_name'] as String).split(',')[0];
              return ListTile(title: Text(name));
            },
            onSuggestionSelected: _onSuggestionSelected,
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              elevation:4, borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(22.0, 79.0),
          initialZoom: 5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.aqi_map',
          ),
          MarkerLayer(markers: _markers),
        ],
      ),
    );
  }
}
