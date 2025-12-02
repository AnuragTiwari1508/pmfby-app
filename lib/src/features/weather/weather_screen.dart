import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _weatherData;
  List<Map<String, dynamic>> _forecastData = [];
  Position? _currentPosition;
  String _selectedCity = 'Delhi';

  // Sample cities for demo - in production, use user's location
  final List<String> _cities = [
    'Delhi',
    'Mumbai',
    'Bangalore',
    'Kolkata',
    'Chennai',
    'Hyderabad',
    'Pune',
    'Ahmedabad',
    'Jaipur',
    'Lucknow',
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() => _isLoading = true);
    
    try {
      // Using OpenWeatherMap API (free tier) for demonstration
      // In production, replace with Indian government APIs when available
      final apiKey = ''; // Add your API key
      
      // Demo data for now - replace with actual API calls
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _weatherData = _getDemoWeatherData();
        _forecastData = _getDemoForecastData();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _weatherData = _getDemoWeatherData();
        _forecastData = _getDemoForecastData();
      });
    }
  }

  Map<String, dynamic> _getDemoWeatherData() {
    return {
      'temp': 28,
      'feels_like': 30,
      'humidity': 65,
      'wind_speed': 12,
      'pressure': 1012,
      'visibility': 10,
      'uv_index': 7,
      'rainfall': 2.5,
      'condition': 'Partly Cloudy',
      'icon': Icons.cloud,
      'sunrise': '06:15',
      'sunset': '18:45',
      'aqi': 85, // Air Quality Index
    };
  }

  List<Map<String, dynamic>> _getDemoForecastData() {
    return [
      {'day': 'Mon', 'high': 32, 'low': 24, 'rain': 20, 'icon': Icons.wb_sunny},
      {'day': 'Tue', 'high': 31, 'low': 23, 'rain': 30, 'icon': Icons.cloud},
      {'day': 'Wed', 'high': 29, 'low': 22, 'rain': 60, 'icon': Icons.grain},
      {'day': 'Thu', 'high': 28, 'low': 21, 'rain': 80, 'icon': Icons.umbrella},
      {'day': 'Fri', 'high': 30, 'low': 23, 'rain': 40, 'icon': Icons.cloud},
      {'day': 'Sat', 'high': 33, 'low': 25, 'rain': 10, 'icon': Icons.wb_sunny},
      {'day': 'Sun', 'high': 34, 'low': 26, 'rain': 5, 'icon': Icons.wb_sunny},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.white,
          ],
        ),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Location Selector
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedCity,
                            isExpanded: true,
                            items: _cities.map((city) {
                              return DropdownMenuItem(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedCity = value);
                                _fetchWeatherData();
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _fetchWeatherData,
                        ),
                      ],
                    ),
                  ),
                ),

                // Current Weather Card
                SliverToBoxAdapter(
                  child: _buildCurrentWeatherCard(),
                ),

                // Weather Metrics Grid
                SliverToBoxAdapter(
                  child: _buildWeatherMetricsGrid(),
                ),

                // 7-Day Forecast
                SliverToBoxAdapter(
                  child: _build7DayForecast(),
                ),

                // Weather Graphs
                SliverToBoxAdapter(
                  child: _buildTemperatureGraph(),
                ),

                SliverToBoxAdapter(
                  child: _buildRainfallGraph(),
                ),

                // Crop Impact Analysis
                SliverToBoxAdapter(
                  child: _buildCropImpactSection(),
                ),

                // Agricultural Advisories
                SliverToBoxAdapter(
                  child: _buildAgriculturalAdvisories(),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
    );
  }

  Widget _buildCurrentWeatherCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade400,
            Colors.blue.shade700,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            _weatherData!['icon'],
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            '${_weatherData!['temp']}°C',
            style: GoogleFonts.poppins(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            _weatherData!['condition'],
            style: GoogleFonts.roboto(
              fontSize: 20,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Feels like ${_weatherData!['feels_like']}°C',
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherStat(
                Icons.water_drop,
                '${_weatherData!['humidity']}%',
                'Humidity',
              ),
              _buildWeatherStat(
                Icons.air,
                '${_weatherData!['wind_speed']} km/h',
                'Wind',
              ),
              _buildWeatherStat(
                Icons.grain,
                '${_weatherData!['rainfall']} mm',
                'Rain',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherMetricsGrid() {
    final metrics = [
      {
        'icon': Icons.compress,
        'label': 'Pressure',
        'value': '${_weatherData!['pressure']} hPa',
        'color': Colors.purple,
      },
      {
        'icon': Icons.visibility,
        'label': 'Visibility',
        'value': '${_weatherData!['visibility']} km',
        'color': Colors.teal,
      },
      {
        'icon': Icons.wb_sunny,
        'label': 'UV Index',
        'value': '${_weatherData!['uv_index']}',
        'color': Colors.orange,
      },
      {
        'icon': Icons.air_outlined,
        'label': 'Air Quality',
        'value': '${_weatherData!['aqi']} AQI',
        'color': Colors.green,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weather Metrics',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: metrics.length,
            itemBuilder: (context, index) {
              final metric = metrics[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      metric['icon'] as IconData,
                      color: metric['color'] as Color,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      metric['value'] as String,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      metric['label'] as String,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _build7DayForecast() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7-Day Forecast',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _forecastData.length,
              itemBuilder: (context, index) {
                final day = _forecastData[index];
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        day['day'],
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        day['icon'],
                        color: Colors.blue.shade700,
                        size: 32,
                      ),
                      Text(
                        '${day['high']}°',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${day['low']}°',
                        style: GoogleFonts.roboto(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.water_drop, size: 12, color: Colors.blue),
                          const SizedBox(width: 2),
                          Text(
                            '${day['rain']}%',
                            style: GoogleFonts.roboto(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureGraph() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temperature Trend',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}°',
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < _forecastData.length) {
                          return Text(
                            _forecastData[value.toInt()]['day'],
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _forecastData.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value['high'].toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.red.shade400,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.shade100.withOpacity(0.3),
                    ),
                  ),
                  LineChartBarData(
                    spots: _forecastData.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value['low'].toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue.shade400,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.shade100.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRainfallGraph() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rainfall Forecast',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < _forecastData.length) {
                          return Text(
                            _forecastData[value.toInt()]['day'],
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _forecastData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value['rain'].toDouble(),
                        color: Colors.blue.shade400,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropImpactSection() {
    final impacts = [
      {
        'crop': 'Wheat',
        'status': 'Favorable',
        'icon': Icons.check_circle,
        'color': Colors.green,
        'details': 'Temperature and moisture levels are optimal for wheat growth.',
      },
      {
        'crop': 'Rice',
        'status': 'Good',
        'icon': Icons.check_circle_outline,
        'color': Colors.lightGreen,
        'details': 'Adequate rainfall expected. Monitor water levels.',
      },
      {
        'crop': 'Cotton',
        'status': 'Caution',
        'icon': Icons.warning,
        'color': Colors.orange,
        'details': 'High temperatures may stress plants. Ensure irrigation.',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crop Impact Analysis',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...impacts.map((impact) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (impact['color'] as Color).withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    impact['icon'] as IconData,
                    color: impact['color'] as Color,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              impact['crop'] as String,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: (impact['color'] as Color).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                impact['status'] as String,
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: impact['color'] as Color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          impact['details'] as String,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAgriculturalAdvisories() {
    final advisories = [
      {
        'title': 'Irrigation Advisory',
        'icon': Icons.water_drop,
        'color': Colors.blue,
        'message': 'Moderate rainfall expected in next 3 days. Reduce irrigation frequency.',
      },
      {
        'title': 'Pest Alert',
        'icon': Icons.bug_report,
        'color': Colors.red,
        'message': 'High humidity may increase pest activity. Monitor crops closely.',
      },
      {
        'title': 'Fertilizer Timing',
        'icon': Icons.eco,
        'color': Colors.green,
        'message': 'Good weather window for fertilizer application in next 48 hours.',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agricultural Advisories',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...advisories.map((advisory) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (advisory['color'] as Color).withOpacity(0.1),
                    Colors.white,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (advisory['color'] as Color).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: advisory['color'] as Color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      advisory['icon'] as IconData,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          advisory['title'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: advisory['color'] as Color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          advisory['message'] as String,
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
