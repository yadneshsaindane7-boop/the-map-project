import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event_type.dart';
import '../repositories/event_type_repository.dart';

final eventTypeRepositoryProvider = Provider<EventTypeRepository>((ref) {
  return EventTypeRepository();
});

final eventTypesProvider = FutureProvider<List<EventType>>((ref) async {
  final repository = ref.watch(eventTypeRepositoryProvider);
  return repository.fetchEventTypes();
});