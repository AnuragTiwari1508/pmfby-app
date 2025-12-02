import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../weather/weather_screen.dart';

class EnhancedSatelliteScreen extends StatefulWidget {
  const EnhancedSatelliteScreen({super.key});

  @override
  State<EnhancedSatelliteScreen> createState() => _EnhancedSatelliteScreenState();
}

class _EnhancedSatelliteScreenState extends State<EnhancedSatelliteScreen> with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  late TabController _tabController;
  bool _showCropHealth = true;
  bool _showWeather = true;
  bool _showDistricts = true;
  bool _showNDVI = false;
  String _selectedLayer = 'satellite';
  Map<String, dynamic>? _selectedFeature;

  // District-wise crop data
  final List<Map<String, dynamic>> districts = [
    {
      'name': 'Hisar, Haryana',
      'location': LatLng(29.1492, 75.7217),
      'totalFarmers': 4589,
      'insuredArea': '12,450 हेक्टेयर',
      'mainCrop': 'गेहूं',
      'cropHealth': 'उत्तम',
      'avgNDVI': 0.82,
      'rainfall': '45mm',
      'temp': '26°C',
      'alerts': 0,
    },
    {
      'name': 'Amravati, Maharashtra',
      'location': LatLng(20.9333, 77.7667),
      'totalFarmers': 8765,
      'insuredArea': '18,900 हेक्टेयर',
      'mainCrop': 'कपास',
      'cropHealth': 'अच्छा',
      'avgNDVI': 0.75,
      'rainfall': '32mm',
      'temp': '32°C',
      'alerts': 1,
    },
    {
      'name': 'Warangal, Telangana',
      'location': LatLng(18.0, 79.5833),
      'totalFarmers': 6543,
      'insuredArea': '15,670 हेक्टेयर',
      'mainCrop': 'धान',
      'cropHealth': 'उत्तम',
      'avgNDVI': 0.88,
      'rainfall': '78mm',
      'temp': '29°C',
      'alerts': 0,
    },
    {
      'name': 'Bikaner, Rajasthan',
      'location': LatLng(28.0229, 73.3119),
      'totalFarmers': 3214,
      'insuredArea': '8,900 हेक्टेयर',
      'mainCrop': 'बाजरा',
      'cropHealth': 'मध्यम',
      'avgNDVI': 0.58,
      'rainfall': '12mm',
      'temp': '38°C',
      'alerts': 2,
    },
    {
      'name': 'Ludhiana, Punjab',
      'location': LatLng(30.9010, 75.8573),
      'totalFarmers': 5896,
      'insuredArea': '16,780 हेक्टेयर',
      'mainCrop': 'गेहूं',
      'cropHealth': 'उत्तम',
      'avgNDVI': 0.85,
      'rainfall': '38mm',
      'temp': '24°C',
      'alerts': 0,
    },
    {
      'name': 'Nashik, Maharashtra',
      'location': LatLng(19.9975, 73.7898),
      'totalFarmers': 4321,
      'insuredArea': '11,230 हेक्टेयर',
      'mainCrop': 'अंगूर',
      'cropHealth': 'अच्छा',
      'avgNDVI': 0.72,
      'rainfall': '28mm',
      'temp': '31°C',
      'alerts': 0,
    },
  ];

  // Weather alerts
  final List<Map<String, dynamic>> weatherAlerts = [
    {
      'location': LatLng(20.9333, 77.7667),
      'district': 'Amravati',
      'type': 'कीट प्रकोप चेतावनी',
      'severity': 'मध्यम',
      'description': 'कपास में गुलाबी सुंडी का प्रकोप संभावित',
      'date': '29-11-2025',
    },
    {
      'location': LatLng(28.0229, 73.3119),
      'district': 'Bikaner',
      'type': 'सूखा चेतावनी',
      'severity': 'उच्च',
      'description': 'अगले 10 दिनों में वर्षा की संभावना कम',
      'date': '28-11-2025',
    },
  ];

  Color _getHealthColor(String health) {
    switch (health) {
      case 'उत्तम':
        return const Color(0xFF2E7D32);
      case 'अच्छा':
        return const Color(0xFF66BB6A);
      case 'मध्यम':
        return const Color(0xFFF57C00);
      default:
        return const Color(0xFFC62828);
    }
  }

  Color _getAlertColor(String severity) {
    switch (severity) {
      case 'उच्च':
        return const Color(0xFFC62828);
      case 'मध्यम':
        return const Color(0xFFF57C00);
      default:
        return const Color(0xFFFFA000);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: Text(
          'Satellite & Weather',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.satellite_alt),
              text: 'Satellite',
            ),
            Tab(
              icon: Icon(Icons.cloud),
              text: 'Weather',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSatelliteView(),
          const WeatherScreen(),
        ],
      ),
    );
  }

  Widget _buildSatelliteView() {
    return Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(23.5937, 78.9629),
              initialZoom: 5.0,
              minZoom: 4.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: _selectedLayer == 'satellite'
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.pmfby.app',
              ),
              // District markers
              if (_showDistricts)
                MarkerLayer(
                  markers: districts.map((district) {
                    return Marker(
                      point: district['location'] as LatLng,
                      width: 60,
                      height: 60,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFeature = district;
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getHealthColor(district['cropHealth']),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.agriculture,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            if (district['alerts'] > 0)
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC62828),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '⚠${district['alerts']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              // Weather alert markers
              if (_showWeather)
                MarkerLayer(
                  markers: weatherAlerts.map((alert) {
                    return Marker(
                      point: alert['location'] as LatLng,
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFeature = alert;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getAlertColor(alert['severity']),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _getAlertColor(alert['severity']).withOpacity(0.5),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.warning,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),

          // Top Controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.satellite_alt,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'भुवन सैटेलाइट निगरानी',
                              style: GoogleFonts.notoSansDevanagari(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ISRO • रीयल-टाइम डेटा',
                              style: GoogleFonts.notoSans(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showFilterBottomSheet(context);
                        },
                        icon: const Icon(
                          Icons.tune,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Quick Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'कुल किसान',
                        '${districts.fold(0, (sum, d) => sum + (d['totalFarmers'] as int))}',
                        Icons.people,
                        const Color(0xFF1565C0),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'सक्रिय अलर्ट',
                        '${weatherAlerts.length}',
                        Icons.warning,
                        const Color(0xFFC62828),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Sheet for selected feature
          if (_selectedFeature != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: _selectedFeature!.containsKey('totalFarmers')
                          ? _buildDistrictDetails(_selectedFeature!)
                          : _buildAlertDetails(_selectedFeature!),
                    ),
                    // Close button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedFeature = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('बंद करें'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Zoom controls
          Positioned(
            right: 16,
            bottom: _selectedFeature != null ? 320 : 100,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoom_in',
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 1,
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: Color(0xFF1B5E20)),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'zoom_out',
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 1,
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove, color: Color(0xFF1B5E20)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121),
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 11,
                    color: const Color(0xFF616161),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistrictDetails(Map<String, dynamic> district) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getHealthColor(district['cropHealth']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.agriculture,
                color: _getHealthColor(district['cropHealth']),
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    district['name'],
                    style: GoogleFonts.notoSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  Text(
                    'मुख्य फसल: ${district['mainCrop']}',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 13,
                      color: const Color(0xFF616161),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDetailRow('कुल किसान', '${district['totalFarmers']}', Icons.people),
        _buildDetailRow('बीमित क्षेत्र', district['insuredArea'], Icons.landscape),
        _buildDetailRow('फसल स्वास्थ्य', district['cropHealth'], Icons.eco),
        _buildDetailRow('NDVI सूचकांक', district['avgNDVI'].toStringAsFixed(2), Icons.analytics),
        _buildDetailRow('वर्षा', district['rainfall'], Icons.water_drop),
        _buildDetailRow('तापमान', district['temp'], Icons.thermostat),
        if (district['alerts'] > 0)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFF57C00)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Color(0xFFF57C00), size: 20),
                const SizedBox(width: 8),
                Text(
                  '${district['alerts']} सक्रिय चेतावनी',
                  style: GoogleFonts.notoSansDevanagari(
                    color: const Color(0xFFF57C00),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAlertDetails(Map<String, dynamic> alert) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getAlertColor(alert['severity']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.warning,
                color: _getAlertColor(alert['severity']),
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert['type'],
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  Text(
                    alert['district'],
                    style: GoogleFonts.notoSans(
                      fontSize: 13,
                      color: const Color(0xFF616161),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getAlertColor(alert['severity']),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                alert['severity'],
                style: GoogleFonts.notoSansDevanagari(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            alert['description'],
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 14,
              color: const Color(0xFF212121),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Color(0xFF616161)),
            const SizedBox(width: 6),
            Text(
              'तिथि: ${alert['date']}',
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 13,
                color: const Color(0xFF616161),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF616161)),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 14,
              color: const Color(0xFF616161),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'मानचित्र फ़िल्टर',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: Text('जिले दिखाएं', style: GoogleFonts.notoSansDevanagari()),
                  value: _showDistricts,
                  activeColor: const Color(0xFF1B5E20),
                  onChanged: (value) {
                    setModalState(() => _showDistricts = value);
                    setState(() => _showDistricts = value);
                  },
                ),
                SwitchListTile(
                  title: Text('मौसम चेतावनी', style: GoogleFonts.notoSansDevanagari()),
                  value: _showWeather,
                  activeColor: const Color(0xFF1B5E20),
                  onChanged: (value) {
                    setModalState(() => _showWeather = value);
                    setState(() => _showWeather = value);
                  },
                ),
                SwitchListTile(
                  title: Text('NDVI विश्लेषण', style: GoogleFonts.notoSansDevanagari()),
                  value: _showNDVI,
                  activeColor: const Color(0xFF1B5E20),
                  onChanged: (value) {
                    setModalState(() => _showNDVI = value);
                    setState(() => _showNDVI = value);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'मानचित्र परत',
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setModalState(() => _selectedLayer = 'satellite');
                          setState(() => _selectedLayer = 'satellite');
                        },
                        icon: const Icon(Icons.satellite),
                        label: Text('सैटेलाइट', style: GoogleFonts.notoSansDevanagari()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedLayer == 'satellite'
                              ? const Color(0xFF1B5E20)
                              : Colors.grey.shade300,
                          foregroundColor: _selectedLayer == 'satellite'
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setModalState(() => _selectedLayer = 'terrain');
                          setState(() => _selectedLayer = 'terrain');
                        },
                        icon: const Icon(Icons.terrain),
                        label: Text('सड़क', style: GoogleFonts.notoSansDevanagari()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedLayer == 'terrain'
                              ? const Color(0xFF1B5E20)
                              : Colors.grey.shade300,
                          foregroundColor: _selectedLayer == 'terrain'
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
