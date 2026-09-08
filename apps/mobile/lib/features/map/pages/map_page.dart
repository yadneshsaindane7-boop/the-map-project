import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/map/camera_fit_service.dart';
import '../../../core/map/map_styles.dart';
import '../../../core/map/map_tile_provider.dart';
import '../../../core/services/notification_service.dart';
import '../../navigation/providers/live_location_provider.dart';
import '../../navigation/providers/navigation_provider.dart';
import '../../navigation/providers/route_provider.dart';
import '../../navigation/widgets/route_polyline.dart';
import '../../search/providers/destination_provider.dart';
import '../../search/widgets/destination_marker.dart';
import '../../search/widgets/search_panel.dart';
import '../models/road_event.dart';
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
  bool _cameraMoved = false;
  MapStyle _selectedStyle = MapStyle.streets;
  DateTime? _lastRouteFit;
  LatLng? _lastSelectedAlertLocation;

  static const double _arrivalThresholdMeters = 30;
  static const double _offRouteThresholdMeters = 50;
  static const Duration _rerouteCooldown = Duration(seconds: 15);

  bool _arrivalHandled = false;
  bool _rerouteInProgress = false;
  DateTime? _lastRerouteTime;

  // Tracks route-relevant active/verified incidents that have already
  // been seen by the navigation screen.
  bool _roadEventsInitialized = false;
  Set<String> _knownRoadEventSignatures = {};

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
    List<RoadEvent> events,
  ) {
    if (events.isEmpty) {
      debugPrint(
        'Zoom to reports skipped: no road events available.',
      );
      return;
    }

    final points = events
        .map(
          (event) => LatLng(
            event.latitude,
            event.longitude,
          ),
        )
        .where(
          (point) =>
              point.latitude.isFinite &&
              point.longitude.isFinite,
        )
        .toList();

    if (points.isEmpty) {
      debugPrint(
        'Zoom to reports skipped: no valid event coordinates.',
      );
      return;
    }

    // flutter_map cannot calculate a finite fit-camera zoom
    // from a zero-area bounds. When there is only one point,
    // move directly to that location instead.
    if (points.length == 1) {
      controller.move(
        points.first,
        16,
      );
      return;
    }

    // If multiple reports have exactly the same coordinates,
    // their bounds still have zero width and height. In that
    // situation, move directly to the shared location.
    final firstPoint = points.first;

    final hasDistinctPoint = points.skip(1).any(
          (point) =>
              point.latitude != firstPoint.latitude ||
              point.longitude != firstPoint.longitude,
        );

    if (!hasDistinctPoint) {
      controller.move(
        firstPoint,
        16,
      );
      return;
    }

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
        now.difference(_lastRerouteTime!) < _rerouteCooldown) {
      return;
    }

    if (route.points.isEmpty) {
      return;
    }

    final routePoints = List<LatLng>.from(route.points);

    final distanceFromRoute = _distanceToRoute(
      userLocation,
      routePoints,
    );

    if (distanceFromRoute <= _offRouteThresholdMeters) {
      return;
    }

    _rerouteInProgress = true;
    _lastRerouteTime = now;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rerouting...'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    try {
      await ref.read(routeProvider.notifier).reroute(
            startLatitude: userLocation.latitude,
            startLongitude: userLocation.longitude,
            endLatitude: destination.latitude,
            endLongitude: destination.longitude,
          );
    } catch (error) {
      debugPrint(
        'Automatic reroute failed: $error',
      );
    } finally {
      _rerouteInProgress = false;
    }
  }

  void _updateJourneyProgress({
    required LatLng userLocation,
    required dynamic destination,
    required dynamic route,
  }) {
    if (route.points.isEmpty) {
      return;
    }

    final straightLineDistance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      destination.latitude,
      destination.longitude,
    );

    if (straightLineDistance <= _arrivalThresholdMeters) {
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

          // Notify the user that the journey has completed.
          unawaited(
            NotificationService.instance.showJourneyCompleted(),
          );

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

    final initialStraightLineDistance = Geolocator.distanceBetween(
      route.points.first.latitude,
      route.points.first.longitude,
      destination.latitude,
      destination.longitude,
    );

    double progressRatio = 1.0;

    if (initialStraightLineDistance > 0) {
      progressRatio =
          straightLineDistance / initialStraightLineDistance;
    }

    progressRatio = progressRatio.clamp(0.0, 1.0);

    final remainingDistance =
        route.distance * progressRatio;

    final remainingDuration =
        (route.time * progressRatio).round();

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
            .updateProgress(
              remainingDistanceMeters: remainingDistance,
              remainingDurationMillis: remainingDuration,
            );
      },
    );
  }

  String _roadEventSignature(RoadEvent event) {
    return '${event.id}|'
        '${event.status.trim().toLowerCase()}|'
        '${event.osmWayId}';
  }

  Set<String> _getRouteRelevantEventSignatures(
    List<RoadEvent> events,
  ) {
    return events
        .where(
          (event) {
            final status =
                event.status.trim().toLowerCase();

            // Approved incident reports appear as "verified"
            // in incident_reports_map_view.
            //
            // "active" is also supported for compatibility
            // with active road-event data.
            return (status == 'verified' ||
                    status == 'active') &&
                event.osmWayId != null;
          },
        )
        .map(_roadEventSignature)
        .toSet();
  }

  void _handleRoadEventChanges(
    List<RoadEvent> events,
  ) {
    final currentSignatures =
        _getRouteRelevantEventSignatures(events);

    debugPrint(
      'Road event provider update received: '
      '${events.length} total events.',
    );

    debugPrint(
      'Route-relevant events currently detected: '
      '${currentSignatures.length}.',
    );

    // The first provider load establishes the baseline.
    // We do not reroute simply because the app started.
    if (!_roadEventsInitialized) {
      _knownRoadEventSignatures =
          currentSignatures;

      _roadEventsInitialized = true;

      debugPrint(
        'Road event baseline initialized: '
        '${currentSignatures.length} '
        'active/verified route-relevant events.',
      );

      return;
    }

    final changed = !_setEquals(
      _knownRoadEventSignatures,
      currentSignatures,
    );

    if (!changed) {
      return;
    }

    debugPrint(
      'Route-relevant road events changed.',
    );

    debugPrint(
      'Previous route-relevant events: '
      '${_knownRoadEventSignatures.length}',
    );

    debugPrint(
      'Current route-relevant events: '
      '${currentSignatures.length}',
    );

    _knownRoadEventSignatures =
        currentSignatures;

    if (!mounted) {
      return;
    }

    final journeyState = ref.read(
      journeyNavigationProvider,
    );

    final routeState = ref.read(
      routeProvider,
    );

    final liveLocationState = ref.read(
      liveLocationProvider,
    );

    final destination = ref.read(
      destinationProvider,
    );

    if (!journeyState.isNavigating) {
      debugPrint(
        'Incident change detected, but navigation '
        'is not active. No reroute.',
      );

      return;
    }

    if (!routeState.hasRoute ||
        routeState.route == null) {
      debugPrint(
        'Incident change detected, but there is '
        'no active route. No reroute.',
      );

      return;
    }

    if (!liveLocationState.hasValue) {
      debugPrint(
        'Incident change detected, but live '
        'location is unavailable. No reroute.',
      );

      return;
    }

    if (destination == null) {
      debugPrint(
        'Incident change detected, but destination '
        'is unavailable. No reroute.',
      );

      return;
    }

    final position =
        liveLocationState.value!;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!mounted) {
          return;
        }

        _rerouteForIncident(
          latitude: position.latitude,
          longitude: position.longitude,
          destination: destination,
        );
      },
    );
  }

  bool _setEquals(
    Set<String> first,
    Set<String> second,
  ) {
    if (first.length != second.length) {
      return false;
    }

    return first.containsAll(second);
  }

  Future<void> _rerouteForIncident({
    required double latitude,
    required double longitude,
    required dynamic destination,
  }) async {
    if (_rerouteInProgress) {
      debugPrint(
        'Incident reroute skipped: '
        'reroute already in progress.',
      );

      return;
    }

    final now = DateTime.now();

    if (_lastRerouteTime != null &&
        now.difference(_lastRerouteTime!) <
            _rerouteCooldown) {
      debugPrint(
        'Incident reroute skipped: cooldown active.',
      );

      return;
    }

    _rerouteInProgress = true;
    _lastRerouteTime = now;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Road incident detected. Rerouting...',
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }

    debugPrint(
      '========== INCIDENT-AWARE REROUTE ==========',
    );

    debugPrint(
      'START: $latitude, $longitude',
    );

    debugPrint(
      'DESTINATION: '
      '${destination.latitude}, '
      '${destination.longitude}',
    );

    debugPrint(
      '============================================',
    );

    try {
      await ref
          .read(routeProvider.notifier)
          .reroute(
            startLatitude: latitude,
            startLongitude: longitude,
            endLatitude: destination.latitude,
            endLongitude: destination.longitude,
          );

      debugPrint(
        'Incident-aware reroute completed.',
      );

      // Notify the user only after the new route
      // has been successfully loaded.
      unawaited(
        NotificationService.instance.showRouteUpdated(),
      );
    } catch (error) {
      debugPrint(
        'Incident-aware reroute failed: $error',
      );
    } finally {
      _rerouteInProgress = false;
    }
  }

  Future<void> _loadRoute({
    required LatLng userLocation,
  }) async {
    final destination = ref.read(
      destinationProvider,
    );

    if (destination == null) {
      return;
    }

    _arrivalHandled = false;
    _rerouteInProgress = false;
    _lastRerouteTime = null;

    debugPrint('');
    debugPrint(
      '========== LOADING ROUTE ==========',
    );

    debugPrint(
      'START: '
      '${userLocation.latitude}, '
      '${userLocation.longitude}',
    );

    debugPrint(
      'DESTINATION: '
      '${destination.latitude}, '
      '${destination.longitude}',
    );

    debugPrint(
      '===================================',
    );

    try {
      await ref
          .read(routeProvider.notifier)
          .loadRoute(
            startLatitude: userLocation.latitude,
            startLongitude: userLocation.longitude,
            endLatitude: destination.latitude,
            endLongitude: destination.longitude,
          );

      if (!mounted) {
        return;
      }

      final routeState = ref.read(
        routeProvider,
      );

      if (routeState.hasRoute &&
          routeState.route != null) {
        final route = routeState.route!;

        debugPrint('');
        debugPrint(
          '========== ROUTE RESULT ==========',
        );

        debugPrint(
          'Route points: '
          '${route.points.length}',
        );

        debugPrint(
          'Route time: '
          '${route.time}',
        );

        debugPrint(
          'Route distance: '
          '${route.distance}',
        );

        debugPrint(
          '==================================',
        );

        if (route.points.length >= 2) {
          mapControllerSafeFit(
            route.points,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Route was returned but contains too few points.',
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              routeState.error ??
                  'Unable to find a route.',
            ),
          ),
        );
      }
    } catch (error) {
      debugPrint(
        'Route loading error: $error',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to load route: $error',
            ),
          ),
        );
      }
    }
  }

  void mapControllerSafeFit(
    List<LatLng> points,
  ) {
    if (points.length < 2) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!mounted) {
          return;
        }

        final controller = ref.read(
          mapControllerProvider,
        );

        controller.fitCamera(
          CameraFitService.fitRoute(points),
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

    ref.listen<AsyncValue<List<RoadEvent>>>(
      roadEventsProvider,
      (previous, next) {
        next.whenData(
          _handleRoadEventChanges,
        );
      },
    );

    if (!journeyState.isNavigating &&
        !journeyState.hasArrived) {
      _arrivalHandled = false;
      _rerouteInProgress = false;
      _lastRerouteTime = null;
    }

    return Scaffold(
      body: initialLocation.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              error.toString(),
            ),
          );
        },
        data: (
          Position initialPosition,
        ) {
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

          if (!_cameraMoved) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                if (!mounted) {
                  return;
                }

                mapController.move(
                  userLocation,
                  17,
                );
              },
            );

            _cameraMoved = true;
          }

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
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                if (!mounted) {
                  return;
                }

                mapController.move(
                  userLocation,
                  18,
                );
              },
            );
          }

          if (routeState.hasRoute &&
              routeState.route != null &&
              routeState.route!.points.length >= 2 &&
              routeState.lastUpdated != null &&
              routeState.lastUpdated !=
                  _lastRouteFit) {
            _lastRouteFit =
                routeState.lastUpdated;

            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
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
              },
            );
          }

          if (journeyState.isNavigating &&
              destination != null &&
              routeState.hasRoute &&
              routeState.route != null &&
              routeState.route!.points.isNotEmpty &&
              liveLocation.hasValue) {
            _updateJourneyProgress(
              userLocation: userLocation,
              destination: destination,
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
                    error: (
                      error,
                      stackTrace,
                    ) =>
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
                  UserLocationMarker(
                    position: userLocation,
                  ),
                ],
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SearchPanel(
                    onDestinationSelected:
                        () async {
                      await _loadRoute(
                        userLocation:
                            userLocation,
                      );
                    },
                  ),
                ),
              ),
              if (routeState.isLoading)
                const Positioned(
                  top: 90,
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
                            Text(
                              'Finding route...',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (routeState.isRerouting)
                const Positioned(
                  top: 90,
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
                            Text(
                              'Rerouting...',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (routeState.error != null)
                Positioned(
                  top: 150,
                  left: 16,
                  right: 16,
                  child: Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding:
                          const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              routeState.error!,
                              maxLines: 3,
                              overflow:
                                  TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 16,
                bottom: 250,
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