import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/pending_report.dart';

class ModerationRepository {
  ModerationRepository()
      : _supabase = Supabase.instance.client;

  final SupabaseClient _supabase;

  Future<List<PendingReport>> fetchPendingReports() async {
    final response = await _supabase
        .from('incident_reports')
        .select()
        .eq('status', 'pending')
        .order('created_at', ascending: false);

    return response
        .map<PendingReport>(
          (json) => PendingReport.fromMap(json),
        )
        .toList();
  }
}