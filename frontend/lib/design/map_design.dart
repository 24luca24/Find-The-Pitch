import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapDesign extends StatelessWidget {
  final LatLng center;
  final double zoom;
  final MapController mapController;
  final LatLng currentLocation;

  const MapDesign({
    Key? key,
    required this.center,
    required this.zoom,
    required this.mapController,
    required this.currentLocation,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 13.0,
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

        // Floating buttons for Zoom and Go Home
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: 'zoomIn',
                mini: true,
                tooltip: 'Zoom In',
                onPressed: () {
                  mapController.move(
                    mapController.camera.center,
                    mapController.camera.zoom + 1,
                  );
                },
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: 'zoomOut',
                mini: true,
                tooltip: 'Zoom Out',
                onPressed: () {
                  mapController.move(
                    mapController.camera.center,
                    mapController.camera.zoom - 1,
                  );
                },
                child: const Icon(Icons.remove),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: 'goHome',
                mini: true,
                tooltip: 'Recenter to My Location',
                onPressed: () {
                  mapController.move(
                    currentLocation, // Ensure this is your latest location
                    13.0,
                  );
                },
                child: const Icon(Icons.home),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
