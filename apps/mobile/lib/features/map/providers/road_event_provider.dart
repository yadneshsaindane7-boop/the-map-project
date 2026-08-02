import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/road_event.dart';
import '../repositories/road_event_repository.dart';

final roadEventRepositoryProvider =
    Provider<RoadEventRepository>((ref) {
  return RoadEventRepository();
});

class RoadEventsNotifier
    extends AsyncNotifier<List<RoadEvent>> {
  late final RoadEventRepository _repository;

  @override
  Future<List<RoadEvent>> build() async {
    _repository = ref.read(
      roadEventRepositoryProvider,
    );

    return _repository.getRoadEvents();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _repository.getRoadEvents(),
    );
  }
}

final roadEventsProvider =
    AsyncNotifierProvider<
        RoadEventsNotifier,
        List<RoadEvent>>(
  RoadEventsNotifier.new,
);