import 'package:latlong2/latlong.dart';

import 'route_instruction.dart';

class RouteModel {
  final double distance;
  final int time;
  final List<LatLng> points;
  final List<RouteInstruction> instructions;

  const RouteModel({
    required this.distance,
    required this.time,
    required this.points,
    required this.instructions,
  });

  factory RouteModel.fromBackend(
    Map<String, dynamic> json,
  ) {
    final rawCoordinates =
        json['coordinates'] as List<dynamic>? ?? [];

    final points = rawCoordinates.map<LatLng>(
      (coordinate) {
        final data =
            coordinate as Map<String, dynamic>;

        return LatLng(
          (data['latitude'] as num).toDouble(),
          (data['longitude'] as num).toDouble(),
        );
      },
    ).toList();

    // Calculate the total route distance from the
    // coordinates returned by the routing backend.
    const distanceCalculator = Distance();

    double totalDistanceMeters = 0;

    for (var index = 0;
        index < points.length - 1;
        index++) {
      totalDistanceMeters += distanceCalculator.as(
        LengthUnit.Meter,
        points[index],
        points[index + 1],
      );
    }

    // Backend returns total_cost_seconds.
    final totalTimeSeconds =
        (json['total_cost_seconds'] as num?)
            ?.toDouble() ??
        0.0;

    return RouteModel(
      distance: totalDistanceMeters,
      time: (totalTimeSeconds * 1000).round(),
      points: points,
      instructions: const [],
    );
  }

  double get distanceKm => distance / 1000;

  double get durationMinutes => time / 60000;
}