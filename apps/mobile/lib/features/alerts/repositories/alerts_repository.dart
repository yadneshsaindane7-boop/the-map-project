import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/traffic_alert.dart';

class AlertsRepository {
  final SupabaseClient _client =
      Supabase.instance.client;

  Future<List<TrafficAlert>> getAlerts() async {
    final response = await _client
        .from('road_events')
        .select()
        .order(
          'created_at',
          ascending: false,
        );

    return response
        .map<TrafficAlert>(
          (json) =>
              TrafficAlert.fromJson(json),
        )
        .toList();
  }
}