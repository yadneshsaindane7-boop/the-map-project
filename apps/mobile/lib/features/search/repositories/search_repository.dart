import '../models/search_result.dart';
import '../services/nominatim_service.dart';
import '../services/photon_service.dart';
import '../utils/search_ranker.dart';

class SearchRepository {
  SearchRepository({
    required PhotonService photonService,
    required NominatimService nominatimService,
  })  : _photonService = photonService,
        _nominatimService = nominatimService;

  final PhotonService _photonService;
  final NominatimService _nominatimService;

  Future<List<SearchResult>> search(String query) async {
    final results = await Future.wait<List<SearchResult>>([
      _safePhotonSearch(query),
      _safeNominatimSearch(query),
    ]);

    final photonResults = results[0];
    final nominatimResults = results[1];

    final merged = _mergeResults(
      photonResults,
      nominatimResults,
    );

    return SearchRanker.rank(
      query: query,
      results: merged,
    );
  }

  Future<List<SearchResult>> _safePhotonSearch(
    String query,
  ) async {
    try {
      return await _photonService.search(query);
    } catch (_) {
      return [];
    }
  }

  Future<List<SearchResult>> _safeNominatimSearch(
    String query,
  ) async {
    try {
      return await _nominatimService.search(query);
    } catch (_) {
      return [];
    }
  }

  List<SearchResult> _mergeResults(
    List<SearchResult> photon,
    List<SearchResult> nominatim,
  ) {
    final merged = <SearchResult>[];
    final seen = <String>{};

    void add(SearchResult result) {
      final key =
          '${result.displayName.toLowerCase()}|'
          '${result.latitude.toStringAsFixed(5)}|'
          '${result.longitude.toStringAsFixed(5)}';

      if (seen.add(key)) {
        merged.add(result);
      }
    }

    // Prefer Photon results first
    for (final result in photon) {
      add(result);
    }

    // Then fill gaps with Nominatim
    for (final result in nominatim) {
      add(result);
    }

    return merged;
  }
}