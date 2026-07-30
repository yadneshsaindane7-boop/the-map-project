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

  factory RouteModel.fromGraphHopper(
    Map<String, dynamic> json,
  ) {
    final path = json['paths'][0];

    final coordinates =
        path['points']['coordinates'] as List<dynamic>;

    final points = coordinates.map((coordinate) {
      return LatLng(
        (coordinate[1] as num).toDouble(),
        (coordinate[0] as num).toDouble(),
      );
    }).toList();

    final instructions =
        (path['instructions'] as List<dynamic>)
            .map(
              (instruction) =>
                  RouteInstruction.fromJson(instruction),
            )
            .toList();

    return RouteModel(
      distance:
          (path['distance'] as num).toDouble(),
      time: path['time'],
      points: points,
      instructions: instructions,
    );
  }

  double get distanceKm => distance / 1000;

  double get durationMinutes => time / 60000;
}