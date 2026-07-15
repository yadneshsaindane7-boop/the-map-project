import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/road_event.dart';
import '../repositories/road_event_repository.dart';

final roadEventRepositoryProvider =
    Provider<RoadEventRepository>((ref) {
  return RoadEventRepository();
});

final roadEventsProvider =
    FutureProvider<List<RoadEvent>>((ref) async {
  return ref.read(roadEventRepositoryProvider).getRoadEvents();
});