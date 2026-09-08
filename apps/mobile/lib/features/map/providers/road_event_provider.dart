import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/road_event.dart';
import '../repositories/road_event_repository.dart';

final roadEventRepositoryProvider =
    Provider<RoadEventRepository>((ref) {
  return RoadEventRepository();
});

class RoadEventsNotifier
    extends AsyncNotifier<List<RoadEvent>> {
  late final RoadEventRepository _repository;

  RealtimeChannel? _channel;

  @override
  Future<List<RoadEvent>> build() async {
    debugPrint(
      '========== BUILD ROAD EVENTS ==========',
    );

    _repository = ref.read(
      roadEventRepositoryProvider,
    );

    final events =
        await _repository.getRoadEvents();

    debugPrint(
      'Initial Road Events Loaded : ${events.length}',
    );

    _subscribeToRealtime();

    ref.onDispose(() async {
      debugPrint(
        'Removing road events realtime channel...',
      );

      if (_channel != null) {
        await Supabase.instance.client
            .removeChannel(
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

    debugPrint(
      'Creating road events realtime channel...',
    );

    _channel = Supabase.instance.client
        .channel('road_events_realtime')
        // -----------------------------------------
        // Incident report changes
        // -----------------------------------------
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'incident_reports',
          callback: (payload) async {
            debugPrint('');

            debugPrint(
              '============= INCIDENT REPORT REALTIME =============',
            );

            debugPrint(
              payload.toString(),
            );

            debugPrint(
              '====================================================',
            );

            await refresh();
          },
        )
        // -----------------------------------------
        // Road event changes
        //
        // IMPORTANT:
        // Resolving an incident changes road_events,
        // not incident_reports.
        // -----------------------------------------
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'road_events',
          callback: (payload) async {
            debugPrint('');

            debugPrint(
              '=============== ROAD EVENT REALTIME ===============',
            );

            debugPrint(
              payload.toString(),
            );

            debugPrint(
              '===================================================',
            );

            await refresh();
          },
        );

    _channel!.subscribe(
      (status, error) {
        debugPrint('');

        debugPrint(
          '============= ROAD EVENT CHANNEL STATUS =============',
        );

        debugPrint(
          status.toString(),
        );

        if (error != null) {
          debugPrint(
            'Channel Error: ${error.toString()}',
          );
        }

        debugPrint(
          '======================================================',
        );
      },
    );
  }

  Future<void> refresh() async {
    debugPrint('');

    debugPrint(
      '============= ROAD EVENTS REFRESH START =============',
    );

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _repository.getRoadEvents(),
    );

    debugPrint(
      '============= ROAD EVENTS REFRESH END ===============',
    );

    debugPrint('');
  }
}

final roadEventsProvider =
    AsyncNotifierProvider<
        RoadEventsNotifier,
        List<RoadEvent>>(
  RoadEventsNotifier.new,
);