import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/search_result.dart';

class NominatimService {
  static const String _baseUrl =
      'https://nominatim.openstreetmap.org/search';

  Future<List<SearchResult>> search(String query) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'q': query,
        'format': 'jsonv2',
        'limit': '10',

        // India only
        'countrycodes': 'in',

        // English names
        'accept-language': 'en',

        // Useful later for address parsing
        'addressdetails': '1',

        // Prefer Nashik area
        'viewbox':
            '73.7000,20.1500,74.1000,19.7500',

        // Bias search toward the viewbox
        'bounded': '0',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'User-Agent': 'TheMapProject/1.0',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to search location');
    }

    final List<dynamic> data = json.decode(response.body);

    return data
        .map((json) => SearchResult.fromJson(json))
        .toList();
  }
}