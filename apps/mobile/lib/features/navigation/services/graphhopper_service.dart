import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_constants.dart';
import '../../map/models/road_event.dart';
import '../models/route_model.dart';

class GraphHopperService {
  static const String _baseUrl =
      'https://graphhopper.com/api/1/route';

  Future<RouteModel> getRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
    List<RoadEvent> roadEvents = const [],
  }) async {
    final url = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'point': [
          '$startLatitude,$startLongitude',
          '$endLatitude,$endLongitude',
        ],
        'profile': 'car',
        'locale': 'en',
        'calc_points': 'true',
        'instructions': 'true',
        'points_encoded': 'false',
        'key': AppConstants.graphHopperApiKey,
      },
    );

    debugPrint('========== GRAPHHOPPER REQUEST ==========');
    debugPrint('URL: $url');
    debugPrint('Road events received: ${roadEvents.length}');
    debugPrint('=========================================');

    final response = await http.get(url);

    debugPrint('========== GRAPHHOPPER RESPONSE ==========');
    debugPrint('Status code: ${response.statusCode}');
    debugPrint('Body: ${response.body}');
    debugPrint('==========================================');

    if (response.statusCode != 200) {
      throw Exception(
        'GraphHopper request failed '
        '(${response.statusCode}): ${response.body}',
      );
    }

    final json =
        jsonDecode(response.body) as Map<String, dynamic>;

    return RouteModel.fromGraphHopper(json);
  }
}