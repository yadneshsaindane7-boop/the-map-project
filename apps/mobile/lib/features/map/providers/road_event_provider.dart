import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/road_event.dart';
import '../repositories/road_event_repository.dart';

final roadEventRepositoryProvider =
    Provider<RoadEventRepository>((ref) {
  return RoadEventRepository();
});

class RoadEventsNotifier extends AsyncNotifier<List<RoadEvent>> {
  late final RoadEventRepository _repository;

  RealtimeChannel? _channel;

  @override
  Future<List<RoadEvent>> build() async {
    debugPrint("========== BUILD ROAD EVENTS ==========");

    _repository = ref.read(
      roadEventRepositoryProvider,
    );

    final events = await _repository.getRoadEvents();

    debugPrint(
      "Initial Road Events Loaded : ${events.length}",
    );

    _subscribeToRealtime();

    ref.onDispose(() async {
      debugPrint("Removing realtime channel...");

      if (_channel != null) {
        await Supabase.instance.client.removeChannel(
          _channel!,
        );
      }
    });

    return events;
  }

  void _subscribeToRealtime() {
    if (_channel != null) {
      return;
    }

    debugPrint("Creating realtime channel...");

    _channel = Supabase.instance.client
        .channel("road_events_realtime")
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: "public",
          table: "road_events",
          callback: (payload) async {
            debugPrint("");
            debugPrint(
                "============= REALTIME EVENT =============");
            debugPrint(payload.toString());
            debugPrint(
                "==========================================");

            await refresh();
          },
        );

    _channel!.subscribe(
      (status, error) {
        debugPrint("");
        debugPrint(
            "============= CHANNEL STATUS =============");
        debugPrint(status.toString());

if (error != null) {
  debugPrint("Channel Error: ${error.toString()}");
}

        debugPrint(
            "==========================================");
      },
    );
  }

  Future<void> refresh() async {
    debugPrint("");
    debugPrint(
        "============= REFRESH START =============");

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _repository.getRoadEvents(),
    );

    debugPrint(
        "============= REFRESH END ===============");
    debugPrint("");
  }
}

final roadEventsProvider =
    AsyncNotifierProvider<
        RoadEventsNotifier,
        List<RoadEvent>>(
  RoadEventsNotifier.new,
);