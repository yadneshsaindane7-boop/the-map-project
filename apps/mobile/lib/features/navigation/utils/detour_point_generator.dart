import 'dart:math';

import 'package:latlong2/latlong.dart';

class DetourPointGenerator {
  static const double _earthRadiusMeters = 6371000;

  /// Generates candidate detour points around a blocked location.
  static List<LatLng> generateCandidates({
    required double latitude,
    required double longitude,
    double radiusMeters = 150,
  }) {
    const bearings = <double>[
      0,
      45,
      90,
      135,
      180,
      225,
      270,
      315,
    ];

    return bearings
        .map(
          (bearing) => _destinationPoint(
            latitude: latitude,
            longitude: longitude,
            distanceMeters: radiusMeters,
            bearingDegrees: bearing,
          ),
        )
        .toList();
  }

  static LatLng _destinationPoint({
    required double latitude,
    required double longitude,
    required double distanceMeters,
    required double bearingDegrees,
  }) {
    final bearingRadians =
        bearingDegrees * pi / 180;

    final latitudeRadians =
        latitude * pi / 180;

    final longitudeRadians =
        longitude * pi / 180;

    final angularDistance =
        distanceMeters / _earthRadiusMeters;

    final newLatitudeRadians = asin(
      sin(latitudeRadians) * cos(angularDistance) +
          cos(latitudeRadians) *
              sin(angularDistance) *
              cos(bearingRadians),
    );

    final newLongitudeRadians =
        longitudeRadians +
            atan2(
              sin(bearingRadians) *
                  sin(angularDistance) *
                  cos(latitudeRadians),
              cos(angularDistance) -
                  sin(latitudeRadians) *
                      sin(newLatitudeRadians),
            );

    return LatLng(
      newLatitudeRadians * 180 / pi,
      newLongitudeRadians * 180 / pi,
    );
  }
}