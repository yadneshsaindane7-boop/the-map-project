import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/search_result.dart';

class PhotonService {
  static const String _baseUrl = 'https://photon.komoot.io/api';

  Future<List<SearchResult>> search(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      return [];
    }

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'q': trimmed,
        'limit': '10',
        'lang': 'en',
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
      throw Exception('Photon search failed');
    }

    final Map<String, dynamic> jsonData =
        json.decode(response.body) as Map<String, dynamic>;

    final List<dynamic> features =
        (jsonData['features'] as List<dynamic>?) ?? [];

    return features.map<SearchResult>((feature) {
      final Map<String, dynamic> properties =
          feature['properties'] as Map<String, dynamic>;

      final Map<String, dynamic> geometry =
          feature['geometry'] as Map<String, dynamic>;

      final List<dynamic> coordinates =
          geometry['coordinates'] as List<dynamic>;

      final parts = [
        properties['name'],
        properties['city'],
        properties['state'],
        properties['country'],
      ]
          .whereType<String>()
          .where((value) => value.trim().isNotEmpty)
          .toList();

      return SearchResult(
        displayName: parts.join(', '),
        latitude: (coordinates[1] as num).toDouble(),
        longitude: (coordinates[0] as num).toDouble(),
      );
    }).toList();
  }
}