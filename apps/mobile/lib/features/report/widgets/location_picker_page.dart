import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/map/map_styles.dart';
import '../../../core/map/map_tile_provider.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({
    super.key,
    required this.initialLocation,
  });

  final LatLng initialLocation;

  @override
  State<LocationPickerPage> createState() =>
      _LocationPickerPageState();
}

class _LocationPickerPageState
    extends State<LocationPickerPage> {
  late final MapController _mapController;

  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();

    _mapController = MapController();

    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Incident Location"),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialLocation,
              initialZoom: 17,
              onTap: (_, point) {
                setState(() {
                  _selectedLocation = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: MapTileProvider.getTileUrl(
                  MapStyle.streets,
                ),
                userAgentPackageName:
                    "com.themapproject.mobile",
              ),

              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 45,
                      height: 45,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 42,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: FilledButton.icon(
              icon: const Icon(Icons.check),
              label: const Text(
                "Use This Location",
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                  _selectedLocation,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}