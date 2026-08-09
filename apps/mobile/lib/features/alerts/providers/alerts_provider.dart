import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/traffic_alert.dart';
import 'alerts_repository_provider.dart';

class AlertsNotifier extends AsyncNotifier<List<TrafficAlert>> {
  RealtimeChannel? _channel;

  @override
  Future<List<TrafficAlert>> build() async {
    debugPrint('========== BUILD ALERTS ==========');

    final alerts = await _loadAlerts();

    debugPrint('Initial Alerts Loaded: ${alerts.length}');

    _subscribeToRealtime();

    ref.onDispose(() async {
      debugPrint('Removing alerts realtime channel...');

      if (_channel != null) {
        await Supabase.instance.client.removeChannel(_channel!);
      }
    });

    return alerts;
  }

  Future<List<TrafficAlert>> _loadAlerts() async {
    return ref
        .read(alertsRepositoryProvider)
        .getAlerts();
  }

  void _subscribeToRealtime() {
    if (_channel != null) {
      return;
    }

    debugPrint('Creating alerts realtime channel...');

    _channel = Supabase.instance.client
        .channel('incident_reports_alerts_realtime')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'incident_reports',
          callback: (payload) async {
            debugPrint('');
            debugPrint('========== ALERT REALTIME EVENT ==========');
            debugPrint(payload.toString());
            debugPrint('==========================================');

            await refresh();
          },
        );

    _channel!.subscribe(
      (status, error) {
        debugPrint('');
        debugPrint('========== ALERT CHANNEL STATUS ==========');
        debugPrint(status.toString());

        if (error != null) {
          debugPrint('Channel Error: ${error.toString()}');
        }

        debugPrint('==========================================');
      },
    );
  }

  Future<void> refresh() async {
    debugPrint('========== ALERT REFRESH START ==========');

    state = const AsyncLoading();

    state = await AsyncValue.guard(
      _loadAlerts,
    );

    debugPrint('========== ALERT REFRESH END ==========');
  }
}

final alertsProvider =
    AsyncNotifierProvider<AlertsNotifier, List<TrafficAlert>>(
  AlertsNotifier.new,
);