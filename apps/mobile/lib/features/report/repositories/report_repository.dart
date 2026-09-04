import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/event_type.dart';

class ReportRepository {
  final SupabaseClient _supabase;

  ReportRepository({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  Future<String> submitReport({
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required EventType eventType,
    required int osmWayId,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('You must be logged in to submit an incident report.');
    }

    final result = await _supabase.rpc(
      'submit_incident_report',
      params: {
        'p_title': title,
        'p_description': description,
        'p_event_type_id': eventType.id,
        'p_user_id': user.id,
        'p_latitude': latitude,
        'p_longitude': longitude,
        'p_osm_way_id': osmWayId,
      },
    );

    return result as String;
  }
}
