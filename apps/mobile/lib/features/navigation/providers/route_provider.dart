import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../map/models/road_event.dart';
import '../../map/providers/road_event_provider.dart';
import '../models/route_model.dart';
import '../services/graphhopper_service.dart';

final graphHopperServiceProvider =
    Provider<GraphHopperService>((ref) {
  return GraphHopperService();
});

class RouteState {
  final bool isLoading;
  final bool isRerouting;
  final RouteModel? route;
  final String? error;
  final DateTime? lastUpdated;

  const RouteState({
    this.isLoading = false,
    this.isRerouting = false,
    this.route,
    this.error,
    this.lastUpdated,
  });

  bool get hasRoute => route != null;

  RouteState copyWith({
    bool? isLoading,
    bool? isRerouting,
    RouteModel? route,
    String? error,
    DateTime? lastUpdated,
  }) {
    return RouteState(
      isLoading: isLoading ?? this.isLoading,
      isRerouting: isRerouting ?? this.isRerouting,
      route: route ?? this.route,
      error: error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class RouteNotifier extends Notifier<RouteState> {
  late final GraphHopperService _service;

  @override
  RouteState build() {
    _service = ref.read(graphHopperServiceProvider);

    return const RouteState();
  }

  List<RoadEvent> _getActiveRoadEvents() {
    final roadEventsState =
        ref.read(roadEventsProvider);

    return roadEventsState.maybeWhen(
      data: (events) => events
          .whereType<RoadEvent>()
          .where((event) => event.shouldAvoid)
          .toList(),
      orElse: () => const <RoadEvent>[],
    );
  }

  Future<void> loadRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    state = RouteState(
      isLoading: true,
      route: state.route,
      lastUpdated: state.lastUpdated,
    );

    try {
      final activeClosures = _getActiveRoadEvents();

      final route = await _service.getRoute(
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
        roadEvents: activeClosures,
      );

      state = RouteState(
        route: route,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = RouteState(
        route: state.route,
        error: e.toString(),
        lastUpdated: state.lastUpdated,
      );
    }
  }

  Future<void> reroute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    if (state.isRerouting) {
      return;
    }

    state = RouteState(
      isRerouting: true,
      route: state.route,
      lastUpdated: state.lastUpdated,
    );

    try {
      final activeClosures = _getActiveRoadEvents();

      final route = await _service.getRoute(
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
        roadEvents: activeClosures,
      );

      state = RouteState(
        route: route,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = RouteState(
        route: state.route,
        error: e.toString(),
        lastUpdated: state.lastUpdated,
      );
    }
  }

  void clearRoute() {
    state = const RouteState();
  }
}

final routeProvider =
    NotifierProvider<RouteNotifier, RouteState>(
  RouteNotifier.new,
);