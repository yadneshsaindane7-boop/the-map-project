import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/map/map_styles.dart';
import '../../../core/map/map_tile_provider.dart';

import '../providers/location_provider.dart';
import '../providers/map_controller_provider.dart';
import '../widgets/road_event_markers.dart';
import '../widgets/user_location_marker.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  bool _cameraMoved = false;

  MapStyle _selectedStyle = MapStyle.streets;

  @override
  Widget build(BuildContext context) {
    final location = ref.watch(currentLocationProvider);
    final mapController = ref.read(mapControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('The Map Project'),
        centerTitle: true,
        actions: [
          PopupMenuButton<MapStyle>(
            icon: const Icon(Icons.layers),
            tooltip: 'Map Style',
            initialValue: _selectedStyle,
            onSelected: (style) {
              setState(() {
                _selectedStyle = style;
              });
            },
            itemBuilder: (context) {
              return MapStyle.values
                  .map(
                    (style) => PopupMenuItem<MapStyle>(
                      value: style,
                      child: Text(style.displayName),
                    ),
                  )
                  .toList();
            },
          ),
        ],
      ),
      body: location.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        data: (Position position) {
          final userLocation = LatLng(
            position.latitude,
            position.longitude,
          );

          if (!_cameraMoved) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              mapController.move(userLocation, 17);
            });

            _cameraMoved = true;
          }

          return FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: userLocation,
              initialZoom: 17,
            ),
            children: [
              TileLayer(
                urlTemplate: MapTileProvider.getTileUrl(
                  _selectedStyle,
                ),
                userAgentPackageName: 'com.themapproject.mobile',
              ),

              UserLocationMarker(
                position: userLocation,
              ),

              const RoadEventMarkers(),
            ],
          );
        },
      ),
    );
  }
}