import '../models/search_result.dart';

class SearchRanker {
  static List<SearchResult> rank({
    required String query,
    required List<SearchResult> results,
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    int score(SearchResult result) {
      final name = result.displayName.toLowerCase();

      int value = 0;

      // Exact match
      if (name == normalizedQuery) {
        value += 100;
      }

      // Starts with query
      if (name.startsWith(normalizedQuery)) {
        value += 70;
      }

      // Contains query
      if (name.contains(normalizedQuery)) {
        value += 40;
      }

      // Prefer Nashik
      if (name.contains('nashik')) {
        value += 50;
      }

      // Prefer Maharashtra
      if (name.contains('maharashtra')) {
        value += 20;
      }

      // Prefer Photon slightly
      if (result.source == 'photon') {
        value += 10;
      }

      return value;
    }

    final ranked = [...results];

    ranked.sort((a, b) => score(b).compareTo(score(a)));

    return ranked.take(10).toList();
  }
}