import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/event_type.dart';

class ReportRepository {
  final SupabaseClient _supabase;

  ReportRepository({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

  Future<String> submitReport({
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required EventType eventType,
  }) async {
    final user = _supabase.auth.currentUser;

    final result = await _supabase.rpc(
      'submit_incident_report',
      params: {
        'p_title': title,
        'p_description': description,
        'p_event_type_id': eventType.id,
        'p_user_id': user?.id,
        'p_latitude': latitude,
        'p_longitude': longitude,
      },
    );

    return result as String;
  }
}