import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/screens/add_field_screen.dart';

import '../design/map_design.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  //Default Milan
  LatLng _currentLocation = LatLng(45.4642, 9.19);
  final double _zoom = 13.0;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _mapController = MapController();
    _loadSavedLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled || permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setDouble('latitude', position.latitude);
      await preferences.setDouble('longitude', position.longitude);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      //Move the map to the new location
      _mapController.move(_currentLocation, _zoom);
    }
  }

  Future<void> _loadSavedLocation() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    double? lat = preferences.getDouble('latitude');
    double? lon = preferences.getDouble('longitude');

    if (lat != null && lon != null) {
      setState(() {
        _currentLocation = LatLng(lat, lon);
      });
      _mapController.move(_currentLocation, _zoom);
    } else {
      await _getUserLocation();
    }
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Fields')),
      body: Column(
        children: [
          // Top controls: buttons and search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[50],
                    foregroundColor: Colors.green[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Filter'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[50],
                    foregroundColor: Colors.green[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Add Field'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name or city',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Full height map minus top controls and bottom nav
          Expanded(
            child: MapDesign(
              center: _currentLocation,
              zoom: _zoom,
              mapController: _mapController,
              currentLocation: _currentLocation,
            ),
          ),
        ],
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Rank'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: 'Book'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RankScreen()),
              );
              break;
            case 2:
              if (context.read<AuthProvider>().isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddFieldScreen()),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Login Required"),
                    content: const Text("You need to be logged in to add a field. Would you like to register or log in now?"),
                    actions: [
                      TextButton(
                        child: const Text("Not Now"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text("Register"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterScreen()),
                          );
                        },
                      ),
                      TextButton(
                        child: const Text("Login"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookingsScreen()),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PersonalAreaScreen()),
              );
              break;
          }
        }
      ),
    );
  }
}
