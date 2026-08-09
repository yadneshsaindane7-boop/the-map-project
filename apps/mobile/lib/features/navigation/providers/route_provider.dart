import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/route_model.dart';
import '../services/routing_backend/routing_backend_service.dart';

final routingBackendServiceProvider =
    Provider<RoutingBackendService>((ref) {
  return RoutingBackendService();
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
    bool clearError = false,
  }) {
    return RouteState(
      isLoading: isLoading ?? this.isLoading,
      isRerouting: isRerouting ?? this.isRerouting,
      route: route ?? this.route,
      error: clearError ? null : error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class RouteNotifier extends Notifier<RouteState> {
  late final RoutingBackendService _service;

  @override
  RouteState build() {
    _service = ref.read(routingBackendServiceProvider);

    return const RouteState();
  }

  Future<void> loadRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    state = state.copyWith(
      isLoading: true,
      isRerouting: false,
      clearError: true,
    );

    try {
      final route = await _service.getRoute(
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
      );

      state = RouteState(
        route: route,
        lastUpdated: DateTime.now(),
      );
    } catch (error) {
      state = RouteState(
        route: state.route,
        error: error.toString(),
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
    if (state.isLoading || state.isRerouting) {
      return;
    }

    state = state.copyWith(
      isRerouting: true,
      clearError: true,
    );

    try {
      final route = await _service.getRoute(
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
      );

      state = RouteState(
        route: route,
        lastUpdated: DateTime.now(),
      );
    } catch (error) {
      state = RouteState(
        route: state.route,
        error: error.toString(),
        lastUpdated: state.lastUpdated,
      );
    }
  }

  void clearRoute() {
    state = const RouteState();
  }

  void clearError() {
    state = state.copyWith(
      clearError: true,
    );
  }
}

final routeProvider =
    NotifierProvider<RouteNotifier, RouteState>(
  RouteNotifier.new,
);