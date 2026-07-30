import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/search_result.dart';

class NominatimService {
  static const String _baseUrl =
      'https://nominatim.openstreetmap.org/search';

  Future<List<SearchResult>> search(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      return [];
    }

    final uri = Uri.parse(
      '$_baseUrl?q=${Uri.encodeQueryComponent(trimmed)}'
      '&format=jsonv2'
      '&limit=10',
    );

    final response = await http.get(
      uri,
      headers: const {
        'User-Agent': 'TheMapProject/1.0',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Search request failed (${response.statusCode})',
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map((json) => SearchResult.fromJson(json))
        .toList();
  }
}