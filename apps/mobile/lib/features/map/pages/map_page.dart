import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/map/camera_fit_service.dart';
import '../../../core/map/map_styles.dart';
import '../../../core/map/map_tile_provider.dart';

import '../../navigation/providers/route_provider.dart';
import '../../navigation/widgets/route_polyline.dart';

import '../../search/providers/destination_provider.dart';
import '../../search/widgets/destination_marker.dart';
import '../../search/widgets/search_panel.dart';

import '../models/road_event.dart';
import '../providers/location_provider.dart';
import '../providers/map_controller_provider.dart';
import '../providers/road_event_provider.dart';

import '../widgets/map_floating_controls.dart';
import '../widgets/road_event_markers.dart';
import '../widgets/route_info_card.dart';
import '../widgets/user_location_marker.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  bool _cameraMoved = false;

  DateTime? _lastRouteFit;

  MapStyle _selectedStyle = MapStyle.streets;

  void _showMapStyleMenu() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: MapStyle.values.map((style) {
              return ListTile(
                leading: const Icon(Icons.map),
                title: Text(style.displayName),
                trailing:
                    style == _selectedStyle
                        ? const Icon(Icons.check)
                        : null,
                onTap: () {
                  Navigator.pop(context);

                  setState(() {
                    _selectedStyle = style;
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _zoomToReports(
    MapController controller,
    List<RoadEvent> events,
  ) {
    if (events.isEmpty) {
      return;
    }

    final points =
        events
            .map(
              (e) => LatLng(
                e.latitude,
                e.longitude,
              ),
            )
            .toList();

    controller.fitCamera(
      CameraFitService.fitPoints(points),
    );
  }

  @override
  Widget build(BuildContext context) {
    final location =
        ref.watch(currentLocationProvider);

    final mapController =
        ref.read(mapControllerProvider);

    final destination =
        ref.watch(destinationProvider);

    final routeState =
        ref.watch(routeProvider);

    final roadEvents =
        ref.watch(roadEventsProvider);

    return Scaffold(
      body: location.when(
        loading:
            () => const Center(
              child:
                  CircularProgressIndicator(),
            ),
        error:
            (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
        data: (Position position) {
          final userLocation = LatLng(
            position.latitude,
            position.longitude,
          );

          if (!_cameraMoved) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) {
              mapController.move(
                userLocation,
                17,
              );
            });

            _cameraMoved = true;
          }

          if (routeState.hasRoute &&
              routeState.lastUpdated != null &&
              routeState.lastUpdated !=
                  _lastRouteFit) {
            _lastRouteFit =
                routeState.lastUpdated;

            WidgetsBinding.instance
                .addPostFrameCallback((_) {
              mapController.fitCamera(
                CameraFitService.fitRoute(
                  routeState.route!.points,
                ),
              );
            });
          } else if (destination != null &&
              !routeState.hasRoute) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) {
              mapController.move(
                LatLng(
                  destination.latitude,
                  destination.longitude,
                ),
                16,
              );
            });
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: userLocation,
                  initialZoom: 17,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        MapTileProvider.getTileUrl(
                          _selectedStyle,
                        ),
                    userAgentPackageName:
                        'com.themapproject.mobile',
                  ),

                  const RoutePolyline(),

                  UserLocationMarker(
                    position: userLocation,
                  ),

                  if (destination != null)
                    DestinationMarker(
                      position: LatLng(
                        destination.latitude,
                        destination.longitude,
                      ),
                    ),

                  roadEvents.when(
                    loading:
                        () => const MarkerLayer(
                          markers: [],
                        ),
                    error:
                        (error, stackTrace) =>
                            const MarkerLayer(
                              markers: [],
                            ),
                    data:
                        (events) => RoadEventMarkers(
                          events: events,
                          currentLocation:
                              userLocation,
                        ),
                  ),
                                  ],
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SearchPanel(
                    onDestinationSelected: () async {
                      final destination =
                          ref.read(destinationProvider);

                      if (destination == null) {
                        ref
                            .read(routeProvider.notifier)
                            .clearRoute();

                        return;
                      }

                      await ref
                          .read(routeProvider.notifier)
                          .loadRoute(
                            startLatitude:
                                userLocation.latitude,
                            startLongitude:
                                userLocation.longitude,
                            endLatitude:
                                destination.latitude,
                            endLongitude:
                                destination.longitude,
                          );
                    },
                  ),
                ),
              ),

              Positioned(
                right: 16,
                bottom: 200,
                child: roadEvents.when(
                  loading: () => const SizedBox.shrink(),
                  error: (error, stackTrace) => const SizedBox.shrink(),
                  data: (events) => FloatingActionButton.small(
                    heroTag: "zoom_reports",
                    tooltip: "Zoom to Reports",
                    backgroundColor: Colors.red,
                    onPressed: () {
                      _zoomToReports(
                        mapController,
                        events,
                      );
                    },
                    child: const Icon(
                      Icons.place,
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 16,
                bottom: 120,
                child: MapFloatingControls(
                  onLayersPressed: _showMapStyleMenu,
                  onMyLocationPressed: () {
                    mapController.move(
                      userLocation,
                      17,
                    );
                  },
                ),
              ),

              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: RouteInfoCard(),
              ),
            ],
          );
        },
      ),
    );
  }
}