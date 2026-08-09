import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/map/camera_fit_service.dart';
import '../../../core/map/map_styles.dart';
import '../../../core/map/map_tile_provider.dart';

import '../../navigation/providers/live_location_provider.dart';
import '../../navigation/providers/navigation_provider.dart';
import '../../navigation/providers/route_provider.dart';
import '../../navigation/widgets/route_polyline.dart';

import '../../search/providers/destination_provider.dart';
import '../../search/widgets/destination_marker.dart';
import '../../search/widgets/search_panel.dart';

import '../providers/location_provider.dart';
import '../providers/map_controller_provider.dart';
import '../providers/road_event_provider.dart';
import '../providers/selected_map_location_provider.dart';

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
  static const double _arrivalThresholdMeters = 30;
  static const double _offRouteThresholdMeters = 50;

  static const Duration _rerouteCooldown =
      Duration(seconds: 15);

  bool _cameraMoved = false;
  bool _arrivalHandled = false;
  bool _rerouteInProgress = false;

  DateTime? _lastRouteFit;
  DateTime? _lastRerouteTime;

  LatLng? _lastSelectedAlertLocation;

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
                trailing: style == _selectedStyle
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
    List events,
  ) {
    if (events.isEmpty) {
      return;
    }

    final points = events
        .map(
          (event) => LatLng(
            event.latitude,
            event.longitude,
          ),
        )
        .toList();

    controller.fitCamera(
      CameraFitService.fitPoints(points),
    );
  }

  double _distanceToRoute(
    LatLng userLocation,
    List<LatLng> routePoints,
  ) {
    if (routePoints.isEmpty) {
      return double.infinity;
    }

    double minimumDistance = double.infinity;

    for (final point in routePoints) {
      final distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        point.latitude,
        point.longitude,
      );

      if (distance < minimumDistance) {
        minimumDistance = distance;
      }
    }

    return minimumDistance;
  }

  Future<void> _checkOffRoute({
    required LatLng userLocation,
    required dynamic destination,
    required dynamic route,
  }) async {
    if (_rerouteInProgress) {
      return;
    }

    final now = DateTime.now();

    if (_lastRerouteTime != null &&
        now.difference(_lastRerouteTime!) <
            _rerouteCooldown) {
      return;
    }

    final routePoints = List<LatLng>.from(
      route.points,
    );

    final distanceFromRoute = _distanceToRoute(
      userLocation,
      routePoints,
    );

    if (distanceFromRoute <=
        _offRouteThresholdMeters) {
      return;
    }

    _rerouteInProgress = true;
    _lastRerouteTime = now;

    debugPrint('');
    debugPrint('========== OFF ROUTE DETECTED ==========');
    debugPrint(
      'Distance from route: '
      '${distanceFromRoute.toStringAsFixed(1)} meters',
    );
    debugPrint('Starting automatic reroute...');
    debugPrint('========================================');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rerouting...'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    try {
      await ref
          .read(routeProvider.notifier)
          .reroute(
            startLatitude: userLocation.latitude,
            startLongitude: userLocation.longitude,
            endLatitude: destination.latitude,
            endLongitude: destination.longitude,
          );

      debugPrint(
        'Automatic reroute completed.',
      );
    } catch (e) {
      debugPrint(
        'Automatic reroute failed: $e',
      );
    } finally {
      _rerouteInProgress = false;
    }
  }

  void _updateCurrentInstruction({
    required LatLng userLocation,
    required dynamic route,
  }) {
    final routePoints = List<LatLng>.from(
      route.points,
    );

    final instructions = route.instructions;

    if (routePoints.length < 2 ||
        instructions.isEmpty) {
      return;
    }

    int nearestPointIndex = 0;
    double nearestDistance = double.infinity;

    for (int i = 0; i < routePoints.length; i++) {
      final distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        routePoints[i].latitude,
        routePoints[i].longitude,
      );

      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearestPointIndex = i;
      }
    }

    final routeProgress =
        nearestPointIndex /
        (routePoints.length - 1);

    int instructionIndex =
        (routeProgress * instructions.length).floor();

    instructionIndex = instructionIndex
        .clamp(
          0,
          instructions.length - 1,
        )
        .toInt();

    final currentInstruction =
        instructions[instructionIndex];

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!mounted) {
          return;
        }

        final journeyState = ref.read(
          journeyNavigationProvider,
        );

        if (!journeyState.isNavigating) {
          return;
        }

        ref
            .read(
              journeyNavigationProvider.notifier,
            )
            .updateInstruction(
              instructionIndex: instructionIndex,
              instruction: currentInstruction,
            );
      },
    );
  }

  void _updateJourneyProgress({
    required LatLng userLocation,
    required dynamic destination,
    required dynamic route,
  }) {
    final straightLineDistance =
        Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      destination.latitude,
      destination.longitude,
    );

    if (straightLineDistance <=
        _arrivalThresholdMeters) {
      if (_arrivalHandled) {
        return;
      }

      _arrivalHandled = true;

      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (!mounted) {
            return;
          }

          ref
              .read(
                journeyNavigationProvider.notifier,
              )
              .arrive();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'You have arrived at your destination.',
              ),
              duration: Duration(seconds: 4),
            ),
          );
        },
      );

      return;
    }

    final initialStraightLineDistance =
        Geolocator.distanceBetween(
      route.points.first.latitude,
      route.points.first.longitude,
      destination.latitude,
      destination.longitude,
    );

    double progressRatio = 1;

    if (initialStraightLineDistance > 0) {
      progressRatio =
          straightLineDistance /
          initialStraightLineDistance;
    }

    progressRatio = progressRatio.clamp(
      0.0,
      1.0,
    );

    final remainingDistance =
        route.distance * progressRatio;

    final remainingDuration =
        (route.time * progressRatio).round();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!mounted) {
          return;
        }

        final currentJourneyState = ref.read(
          journeyNavigationProvider,
        );

        if (!currentJourneyState.isNavigating) {
          return;
        }

        ref
            .read(
              journeyNavigationProvider.notifier,
            )
            .updateProgress(
              remainingDistanceMeters:
                  remainingDistance,
              remainingDurationMillis:
                  remainingDuration,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final initialLocation = ref.watch(
      currentLocationProvider,
    );

    final liveLocation = ref.watch(
      liveLocationProvider,
    );

    final journeyState = ref.watch(
      journeyNavigationProvider,
    );

    final mapController = ref.read(
      mapControllerProvider,
    );

    final destination = ref.watch(
      destinationProvider,
    );

    final routeState = ref.watch(
      routeProvider,
    );

    final roadEvents = ref.watch(
      roadEventsProvider,
    );

    final selectedAlertLocation = ref.watch(
      selectedMapLocationProvider,
    );

    if (!journeyState.isNavigating &&
        !journeyState.hasArrived) {
      _arrivalHandled = false;
      _rerouteInProgress = false;
      _lastRerouteTime = null;
    }

    return Scaffold(
      body: initialLocation.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        data: (Position initialPosition) {
          LatLng userLocation = LatLng(
            initialPosition.latitude,
            initialPosition.longitude,
          );

          if (journeyState.isNavigating &&
              liveLocation.hasValue) {
            final livePosition =
                liveLocation.value!;

            userLocation = LatLng(
              livePosition.latitude,
              livePosition.longitude,
            );
          }

          if (journeyState.isNavigating &&
              destination != null &&
              routeState.hasRoute &&
              liveLocation.hasValue) {
            _updateJourneyProgress(
              userLocation: userLocation,
              destination: destination,
              route: routeState.route!,
            );

            _updateCurrentInstruction(
              userLocation: userLocation,
              route: routeState.route!,
            );

            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                if (!mounted) {
                  return;
                }

                _checkOffRoute(
                  userLocation: userLocation,
                  destination: destination,
                  route: routeState.route!,
                );
              },
            );
          }

          // Move the map to the alert selected
          // from the Alerts page.
          if (selectedAlertLocation != null &&
              selectedAlertLocation !=
                  _lastSelectedAlertLocation) {
            _lastSelectedAlertLocation =
                selectedAlertLocation;

            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                if (!mounted) {
                  return;
                }

                mapController.move(
                  selectedAlertLocation,
                  17,
                );
              },
            );
          }

          if (journeyState.isNavigating &&
              liveLocation.hasValue) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }

              mapController.move(
                userLocation,
                18,
              );
            });
          }

          if (!_cameraMoved) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }

              mapController.move(
                userLocation,
                17,
              );
            });

            _cameraMoved = true;
          }

          if (routeState.hasRoute &&
              routeState.lastUpdated != null &&
              routeState.lastUpdated != _lastRouteFit) {
            _lastRouteFit =
                routeState.lastUpdated;

            WidgetsBinding.instance
                .addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }

              if (!journeyState.isNavigating &&
                  selectedAlertLocation == null) {
                mapController.fitCamera(
                  CameraFitService.fitRoute(
                    routeState.route!.points,
                  ),
                );
              }
            });
          } else if (destination != null &&
              !routeState.hasRoute &&
              selectedAlertLocation == null) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }

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
                    loading: () =>
                        const MarkerLayer(
                      markers: [],
                    ),
                    error: (error, stackTrace) =>
                        const MarkerLayer(
                      markers: [],
                    ),
                    data: (events) =>
                        RoadEventMarkers(
                      events: events,
                      currentLocation:
                          userLocation,
                    ),
                  ),
                ],
              ),

              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: SearchPanel(
                    onDestinationSelected:
                        () async {
                      _arrivalHandled = false;
                      _rerouteInProgress = false;
                      _lastRerouteTime = null;

                      ref
                          .read(
                            journeyNavigationProvider
                                .notifier,
                          )
                          .stopNavigation();

                      final selectedDestination =
                          ref.read(
                        destinationProvider,
                      );

                      if (selectedDestination ==
                          null) {
                        ref
                            .read(
                              routeProvider.notifier,
                            )
                            .clearRoute();

                        return;
                      }

                      await ref
                          .read(
                            routeProvider.notifier,
                          )
                          .loadRoute(
                            startLatitude:
                                userLocation.latitude,
                            startLongitude:
                                userLocation.longitude,
                            endLatitude:
                                selectedDestination
                                    .latitude,
                            endLongitude:
                                selectedDestination
                                    .longitude,
                          );
                    },
                  ),
                ),
              ),

              if (routeState.isRerouting)
                const Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Rerouting...'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              Positioned(
                right: 16,
                bottom: 200,
                child: roadEvents.when(
                  loading: () =>
                      const SizedBox.shrink(),
                  error: (
                    error,
                    stackTrace,
                  ) =>
                      const SizedBox.shrink(),
                  data: (events) =>
                      FloatingActionButton.small(
                    heroTag: 'zoom_reports',
                    tooltip: 'Zoom to Reports',
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
                  onLayersPressed:
                      _showMapStyleMenu,
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