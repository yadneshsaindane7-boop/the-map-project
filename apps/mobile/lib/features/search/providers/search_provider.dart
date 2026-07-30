import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/search_result.dart';
import '../services/nominatim_service.dart';

final nominatimServiceProvider = Provider<NominatimService>((ref) {
  return NominatimService();
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
  late final NominatimService _service;

  @override
  SearchState build() {
    _service = ref.read(nominatimServiceProvider);
    return const SearchState();
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        results: const [],
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
    );

    try {
      final results = await _service.search(trimmed);

      state = state.copyWith(
        isLoading: false,
        results: results,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        results: const [],
      );
    }
  }

  void clearResults() {
    state = state.copyWith(
      isLoading: false,
      results: const [],
    );
  }
}

final searchProvider =
    NotifierProvider<SearchNotifier, SearchState>(
  SearchNotifier.new,
);