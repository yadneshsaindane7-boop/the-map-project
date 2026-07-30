import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/app_constants.dart';
import '../models/route_model.dart';

class GraphHopperService {
  static const String _baseUrl =
      'https://graphhopper.com/api/1/route';

  Future<RouteModel> getRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    final url =
        '$_baseUrl'
        '?point=$startLatitude,$startLongitude'
        '&point=$endLatitude,$endLongitude'
        '&profile=car'
        '&locale=en'
        '&calc_points=true'
        '&instructions=true'
        '&points_encoded=false'
        '&key=${AppConstants.graphHopperApiKey}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception(
        'GraphHopper request failed (${response.statusCode})',
      );
    }

    final json =
        jsonDecode(response.body) as Map<String, dynamic>;

    return RouteModel.fromGraphHopper(json);
  }
}