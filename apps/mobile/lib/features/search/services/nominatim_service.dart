import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/search_result.dart';

class NominatimService {
  static const String _baseUrl =
      'https://nominatim.openstreetmap.org/search';

  static const List<String> _knownLocations = [
    'nashik',
    'nasik',
    'mumbai',
    'pune',
    'delhi',
    'bangalore',
    'bengaluru',
    'hyderabad',
    'chennai',
    'kolkata',
    'agra',
    'jaipur',
    'surat',
    'ahmedabad',
    'india',
    'maharashtra',
  ];

  String _prepareQuery(String query) {
    final lower = query.toLowerCase();

    final hasLocation = _knownLocations.any(
      (location) => lower.contains(location),
    );

    if (hasLocation) {
      return query;
    }

    return '$query, Nashik, Maharashtra, India';
  }

  Future<List<SearchResult>> search(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return [];
    }

    final searchQuery = _prepareQuery(trimmedQuery);

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'q': searchQuery,
        'format': 'jsonv2',
        'limit': '10',

        // Restrict to India
        'countrycodes': 'in',

        // English results
        'accept-language': 'en',

        // Include address details
        'addressdetails': '1',

        // Prefer Nashik region
        'viewbox':
            '73.7000,20.1500,74.1000,19.7500',

        // Bias toward Nashik but don't restrict
        'bounded': '0',

        // Return more useful POIs
        'extratags': '1',
        'namedetails': '1',
      },
    );

    final response = await http.get(
      uri,
      headers: const {
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