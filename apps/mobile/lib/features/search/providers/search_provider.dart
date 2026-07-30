import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/search_result.dart';
import '../repositories/search_repository.dart';
import '../services/nominatim_service.dart';
import '../services/photon_service.dart';
import '../services/search_service.dart';

final photonServiceProvider = Provider<PhotonService>((ref) {
  return PhotonService();
});

final nominatimServiceProvider = Provider<NominatimService>((ref) {
  return NominatimService();
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(
    photonService: ref.read(photonServiceProvider),
    nominatimService: ref.read(nominatimServiceProvider),
  );
});

final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService(
    repository: ref.read(searchRepositoryProvider),
  );
});

class SearchState {
  final bool isLoading;
  final List<SearchResult> results;

  const SearchState({
    this.isLoading = false,
    this.results = const [],
  });

  SearchState copyWith({
    bool? isLoading,
    List<SearchResult>? results,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
    );
  }
}

class SearchNotifier extends Notifier<SearchState> {
  late final SearchService _searchService;

  @override
  SearchState build() {
    _searchService = ref.read(searchServiceProvider);
    return const SearchState();
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      state = const SearchState();
      return;
    }

    state = state.copyWith(
      isLoading: true,
    );

    try {
      final results = await _searchService.search(trimmed);

      state = SearchState(
        isLoading: false,
        results: results,
      );
    } catch (_) {
      state = const SearchState();
    }
  }

  void clearResults() {
    state = const SearchState();
  }
}

final searchProvider =
    NotifierProvider<SearchNotifier, SearchState>(
  SearchNotifier.new,
);