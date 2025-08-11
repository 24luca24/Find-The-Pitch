import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapDesign extends StatelessWidget {
  final LatLng center;
  final double zoom;
  final MapController mapController;
  final LatLng currentLocation;

  const MapDesign({
    super.key,
    required this.center,
    required this.zoom,
    required this.mapController,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: zoom,
              minZoom: 3.0,
              maxZoom: 18.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.frontend',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: center,
                    width: 60,
                    height: 60,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Zoom and Location Controls
          Positioned(
            bottom: 20,
            right: 12,
            child: Column(
              children: [
                _buildMapButton(Icons.add, 'zoomIn', () {
                  mapController.move(
                    mapController.camera.center,
                    mapController.camera.zoom + 1,
                  );
                }),
                const SizedBox(height: 10),
                _buildMapButton(Icons.remove, 'zoomOut', () {
                  mapController.move(
                    mapController.camera.center,
                    mapController.camera.zoom - 1,
                  );
                }),
                const SizedBox(height: 10),
                _buildMapButton(Icons.home, 'goHome', () {
                  mapController.move(currentLocation, 13.0);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapButton(IconData icon, String heroTag,
      VoidCallback onPressed) {
    return FloatingActionButton(
      heroTag: heroTag,
      mini: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}