import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/search_result.dart';

class DestinationNotifier extends Notifier<SearchResult?> {
  @override
  SearchResult? build() {
    return null;
  }

  void setDestination(SearchResult destination) {
    state = destination;
  }

  void clearDestination() {
    state = null;
  }
}

final destinationProvider =
    NotifierProvider<DestinationNotifier, SearchResult?>(
  DestinationNotifier.new,
);