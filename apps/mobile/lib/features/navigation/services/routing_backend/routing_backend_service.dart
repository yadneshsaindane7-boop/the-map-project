import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';
import '../../models/route_model.dart';

class RoutingBackendService {
  Future<RouteModel> getRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    final url = Uri.parse(
      '${AppConstants.routingBackendUrl}/api/routing/route',
    );

    final response = await http
        .post(
          url,
          headers: const {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'start_latitude': startLatitude,
            'start_longitude': startLongitude,
            'end_latitude': endLatitude,
            'end_longitude': endLongitude,
          }),
        )
        .timeout(
          const Duration(seconds: 60),
        );

    if (response.statusCode != 200) {
      throw Exception(
        'Routing backend request failed '
        '(${response.statusCode}): ${response.body}',
      );
    }

    final json = jsonDecode(
      response.body,
    ) as Map<String, dynamic>;

    if (json['success'] != true) {
      throw Exception(
        'Routing backend did not return a successful route.',
      );
    }

    return RouteModel.fromBackend(json);
  }
}