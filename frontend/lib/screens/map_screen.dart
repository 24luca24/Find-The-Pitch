import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  double _zoom = 13.0;

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
                ElevatedButton(onPressed: () {}, child: const Text('Filter')),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () {}, child: const Text('Add Field')),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by name or city',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Map view (from map_design.dart)
          Expanded(
              child: MapDesign(
                center: _currentLocation,
                zoom: _zoom,
                mapController: _mapController,
                currentLocation: _currentLocation,
              )),
        ],
      ),
    );
  }
}