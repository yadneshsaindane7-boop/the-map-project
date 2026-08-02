import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CameraFitService {
  const CameraFitService._();

  static CameraFit fitRoute(List<LatLng> points) {
    return fitPoints(points);
  }

  static CameraFit fitPoints(List<LatLng> points) {
    if (points.isEmpty) {
      throw ArgumentError(
        'Points cannot be empty.',
      );
    }

    double minLatitude = points.first.latitude;
    double maxLatitude = points.first.latitude;

    double minLongitude = points.first.longitude;
    double maxLongitude = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLatitude) {
        minLatitude = point.latitude;
      }

      if (point.latitude > maxLatitude) {
        maxLatitude = point.latitude;
      }

      if (point.longitude < minLongitude) {
        minLongitude = point.longitude;
      }

      if (point.longitude > maxLongitude) {
        maxLongitude = point.longitude;
      }
    }

    final bounds = LatLngBounds(
      LatLng(
        minLatitude,
        minLongitude,
      ),
      LatLng(
        maxLatitude,
        maxLongitude,
      ),
    );

    return CameraFit.bounds(
      bounds: bounds,
      padding: const EdgeInsets.all(60),
    );
  }
}