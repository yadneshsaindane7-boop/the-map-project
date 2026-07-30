import '../models/search_result.dart';
import '../repositories/search_repository.dart';

class SearchService {
  SearchService({
    required SearchRepository repository,
  }) : _repository = repository;

  final SearchRepository _repository;

  static const List<String> _knownLocations = [
    'nashik',
    'nasik',
    'mumbai',
    'pune',
    'nagpur',
    'thane',
    'aurangabad',
    'kolhapur',
    'maharashtra',
    'india',
  ];

  Future<List<SearchResult>> search(String query) async {
    final queries = _buildQueries(query);

    for (final q in queries) {
      final results = await _repository.search(q);

      // Good enough, stop searching.
      if (results.length >= 5) {
        return results;
      }

      if (results.isNotEmpty) {
        return results;
      }
    }

    return [];
  }

  List<String> _buildQueries(String query) {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      return [];
    }

    final lower = trimmed.toLowerCase();

    final hasLocation = _knownLocations.any(
      lower.contains,
    );

    if (hasLocation) {
      return [trimmed];
    }

    return [
      '$trimmed, Nashik, Maharashtra',
      '$trimmed, Maharashtra',
      '$trimmed, India',
      trimmed,
    ];
  }
}