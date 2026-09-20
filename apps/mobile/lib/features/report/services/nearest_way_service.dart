import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../core/services/local_backend_discovery_service.dart';

class NearestWayResult {
  const NearestWayResult({
    required this.osmWayId,
    required this.distanceMeters,
    required this.snappedLatitude,
    required this.snappedLongitude,
    this.name,
    this.highway,
  });

  final int osmWayId;
  final double distanceMeters;
  final double snappedLatitude;
  final double snappedLongitude;
  final String? name;
  final String? highway;

  LatLng get snappedLocation {
    return LatLng(
      snappedLatitude,
      snappedLongitude,
    );
  }

  factory NearestWayResult.fromJson(
    Map<String, dynamic> json,
  ) {
    final osmWayIdValue = json['osm_way_id'];

    if (osmWayIdValue == null) {
      throw const FormatException(
        'Routing backend did not return an OSM way ID.',
      );
    }

    final osmWayId = osmWayIdValue is num
        ? osmWayIdValue.toInt()
        : int.parse(
            osmWayIdValue.toString(),
          );

    final distanceValue = json['distance_meters'];
    final snappedLatitudeValue =
        json['snapped_latitude'];
    final snappedLongitudeValue =
        json['snapped_longitude'];

    if (snappedLatitudeValue == null ||
        snappedLongitudeValue == null) {
      throw const FormatException(
        'Routing backend did not return a snapped road location.',
      );
    }

    return NearestWayResult(
      osmWayId: osmWayId,
      distanceMeters: distanceValue is num
          ? distanceValue.toDouble()
          : double.parse(
              distanceValue.toString(),
            ),
      snappedLatitude: snappedLatitudeValue is num
          ? snappedLatitudeValue.toDouble()
          : double.parse(
              snappedLatitudeValue.toString(),
            ),
      snappedLongitude: snappedLongitudeValue is num
          ? snappedLongitudeValue.toDouble()
          : double.parse(
              snappedLongitudeValue.toString(),
            ),
      name: json['name'] as String?,
      highway: json['highway'] as String?,
    );
  }
}

class NearestWayService {
  final LocalBackendDiscoveryService _discovery =
      LocalBackendDiscoveryService();

  Future<NearestWayResult> resolveNearestWay(
    LatLng location,
  ) async {
    final backendUrl = await _discovery.getBackendUrl();

    final uri = Uri.parse(
      '$backendUrl/api/routing/nearest-way',
    ).replace(
      queryParameters: {
        'latitude': location.latitude.toString(),
        'longitude': location.longitude.toString(),
      },
    );

    final response = await http
        .get(
          uri,
          headers: const {
            'Accept': 'application/json',
          },
        )
        .timeout(
          const Duration(seconds: 30),
        );

    if (response.statusCode != 200) {
      String message =
          'Failed to resolve the incident location to a road.';

      try {
        final body = jsonDecode(response.body)
            as Map<String, dynamic>;

        final detail = body['detail'];

        if (detail is String &&
            detail.trim().isNotEmpty) {
          message = detail;
        }
      } catch (_) {}

      throw Exception(
        '$message (${response.statusCode})',
      );
    }

    final json = jsonDecode(response.body)
        as Map<String, dynamic>;

    if (json['success'] != true) {
      throw Exception(
        'Routing backend could not resolve the selected road.',
      );
    }

    return NearestWayResult.fromJson(json);
  }
}