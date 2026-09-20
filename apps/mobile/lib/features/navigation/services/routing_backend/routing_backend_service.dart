import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/services/local_backend_discovery_service.dart';
import '../../models/route_model.dart';

class RoutingBackendService {
  final LocalBackendDiscoveryService _discovery =
      LocalBackendDiscoveryService();

  Future<RouteModel> getRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    final backendUrl = await _discovery.getBackendUrl();

    final url = Uri.parse(
      '$backendUrl/api/routing/route',
    );

    debugPrint('========== ROUTING REQUEST ==========');
    debugPrint('URL: $url');
    debugPrint('START: $startLatitude, $startLongitude');
    debugPrint('DESTINATION: $endLatitude, $endLongitude');

    final stopwatch = Stopwatch()..start();

    try {
      debugPrint('Sending POST request...');

      final response = await http
          .post(
            url,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'start_latitude': startLatitude,
              'start_longitude': startLongitude,
              'end_latitude': endLatitude,
              'end_longitude': endLongitude,
            }),
          )
          .timeout(const Duration(seconds: 60));

      stopwatch.stop();

      debugPrint(
        'Response received after '
        '${stopwatch.elapsedMilliseconds} ms',
      );
      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response length: ${response.body.length}');

      if (response.statusCode != 200) {
        throw Exception(
          'Routing backend request failed '
          '(${response.statusCode}): ${response.body}',
        );
      }

      debugPrint('Decoding JSON...');

      final json = jsonDecode(response.body)
          as Map<String, dynamic>;

      debugPrint('JSON decoded successfully');
      debugPrint('success: ${json['success']}');
      debugPrint(
        'coordinate count: '
        '${(json['coordinates'] as List<dynamic>?)?.length ?? 0}',
      );

      if (json['success'] != true) {
        throw Exception(
          'Routing backend did not return a successful route.',
        );
      }

      debugPrint('Creating RouteModel...');

      final route = RouteModel.fromBackend(json);

      debugPrint('RouteModel created successfully');
      debugPrint('points: ${route.points.length}');
      debugPrint('distance: ${route.distance} m');
      debugPrint(
        'duration: ${route.durationMinutes} min',
      );
      debugPrint('========== ROUTING COMPLETE ==========');

      return route;
    } catch (error, stackTrace) {
      stopwatch.stop();

      debugPrint(
        'ROUTING FAILED after '
        '${stopwatch.elapsedMilliseconds} ms',
      );
      debugPrint('ERROR: $error');
      debugPrint('$stackTrace');

      rethrow;
    }
  }
}