import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

import '../models/maneuver_type.dart';
import '../models/route_instruction.dart';

class ManeuverCalculator {
  static const double _straightThresholdDegrees = 15.0;
  static const double _mergeDistanceMeters = 40.0;

  static double _bearing(LatLng a, LatLng b) {
    final lat1 = a.latitudeInRad;
    final lat2 = b.latitudeInRad;
    final dLon = b.longitudeInRad - a.longitudeInRad;

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }

  static double _distanceMeters(LatLng a, LatLng b) {
    const r = 6371000.0;
    final dLat = b.latitudeInRad - a.latitudeInRad;
    final dLon = b.longitudeInRad - a.longitudeInRad;
    final sinLat = math.sin(dLat / 2);
    final sinLon = math.sin(dLon / 2);

    final h = sinLat * sinLat +
        math.cos(a.latitudeInRad) *
            math.cos(b.latitudeInRad) *
            sinLon *
            sinLon;

    return 2 * r * math.asin(math.sqrt(h.clamp(0.0, 1.0)));
  }

  static List<RouteInstruction> calculate(List<LatLng> points) {
    if (points.length < 2) {
      return [];
    }

    final cumulative = List<double>.filled(points.length, 0);

    for (var i = 1; i < points.length; i++) {
      cumulative[i] = cumulative[i - 1] +
          _distanceMeters(points[i - 1], points[i]);
    }

    final turns = <RouteInstruction>[];
    var lastTurnDistance = -_mergeDistanceMeters;

    for (var i = 1; i < points.length - 1; i++) {
      final bearing1 = _bearing(points[i - 1], points[i]);
      final bearing2 = _bearing(points[i], points[i + 1]);
      final angle = (bearing2 - bearing1 + 360) % 360;
      final deflection = math.min(angle, 360 - angle);

      if (deflection < _straightThresholdDegrees) {
        continue;
      }

      final distanceFromStart = cumulative[i];

      if (distanceFromStart - lastTurnDistance <
          _mergeDistanceMeters) {
        continue;
      }

      final maneuver = ManeuverType.fromAngle(angle);

      turns.add(
        RouteInstruction(
          text: _maneuverText(maneuver),
          distance: 0,
          time: 0,
          sign: maneuver.sign,
          pointIndex: i,
          distanceFromStart: distanceFromStart,
        ),
      );

      lastTurnDistance = distanceFromStart;
    }

    final instructions = <RouteInstruction>[];
    var previousDistance = 0.0;

    for (final turn in turns) {
      final turnDistance = turn.distanceFromStart!;

      instructions.add(
        RouteInstruction(
          text: turn.text,
          distance: turnDistance - previousDistance,
          time: ((turnDistance - previousDistance) /
                  (30 * 1000 / 3600) *
                  1000)
              .round(),
          sign: turn.sign,
          pointIndex: turn.pointIndex,
          distanceFromStart: turnDistance,
        ),
      );

      previousDistance = turnDistance;
    }

    instructions.add(
      RouteInstruction(
        text: 'arrived',
        distance: cumulative.last - previousDistance,
        time: ((cumulative.last - previousDistance) /
                (30 * 1000 / 3600) *
                1000)
            .round(),
        sign: ManeuverType.arrived.sign,
        pointIndex: points.length - 1,
        distanceFromStart: cumulative.last,
      ),
    );

    return instructions;
  }

  static int currentInstructionIndex({
    required List<RouteInstruction> instructions,
    required double remainingDistanceMeters,
    required double totalRouteDistanceMeters,
  }) {
    if (instructions.isEmpty) {
      return 0;
    }

    final travelled = (totalRouteDistanceMeters -
            remainingDistanceMeters)
        .clamp(0.0, totalRouteDistanceMeters);

    for (var i = 0; i < instructions.length; i++) {
      final distance = instructions[i].distanceFromStart;

      if (distance != null && travelled < distance) {
        return i;
      }
    }

    return instructions.length - 1;
  }

  static String _maneuverText(ManeuverType maneuver) {
    switch (maneuver) {
      case ManeuverType.continueStraight:
        return 'continue_straight';
      case ManeuverType.slightRight:
        return 'slight_right';
      case ManeuverType.right:
        return 'turn_right';
      case ManeuverType.sharpRight:
        return 'sharp_right';
      case ManeuverType.uTurn:
        return 'u_turn';
      case ManeuverType.sharpLeft:
        return 'sharp_left';
      case ManeuverType.left:
        return 'turn_left';
      case ManeuverType.slightLeft:
        return 'slight_left';
      case ManeuverType.arrived:
        return 'arrived';
    }
  }
}
