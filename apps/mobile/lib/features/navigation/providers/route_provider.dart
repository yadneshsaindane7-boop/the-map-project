import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/route_model.dart';
import '../services/graphhopper_service.dart';

final graphHopperServiceProvider =
    Provider<GraphHopperService>((ref) {
  return GraphHopperService();
});

class RouteState {
  final bool isLoading;
  final RouteModel? route;
  final String? error;
  final DateTime? lastUpdated;

  const RouteState({
    this.isLoading = false,
    this.route,
    this.error,
    this.lastUpdated,
  });

  bool get hasRoute => route != null;

  RouteState copyWith({
    bool? isLoading,
    RouteModel? route,
    String? error,
    DateTime? lastUpdated,
  }) {
    return RouteState(
      isLoading: isLoading ?? this.isLoading,
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

  Future<void> loadRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final route = await _service.getRoute(
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
      );

      state = RouteState(
        isLoading: false,
        route: route,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = RouteState(
        isLoading: false,
        error: e.toString(),
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