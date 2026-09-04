import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/pending_report.dart';

class ModerationRepository {
  ModerationRepository() : _supabase = Supabase.instance.client;

  final SupabaseClient _supabase;

  Future<List<PendingReport>> fetchPendingReports() async {
    final response = await _supabase
        .from('incident_reports_map_view')
        .select()
        .eq('status', 'pending')
        .order('created_at', ascending: false);

    return response
        .map<PendingReport>((json) => PendingReport.fromMap(json))
        .toList();
  }

  Future<Map<String, dynamic>> approveReport(String reportId) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'You must be logged in to approve an incident report.',
      );
    }

    final result = await _supabase.rpc(
      'approve_incident_report',
      params: {
        'p_report_id': reportId,
        'p_authority_id': user.id,
      },
    );

    return Map<String, dynamic>.from(result as Map);
  }

  Future<Map<String, dynamic>> rejectReport(String reportId) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'You must be logged in to reject an incident report.',
      );
    }

    final result = await _supabase.rpc(
      'reject_incident_report',
      params: {
        'p_report_id': reportId,
        'p_authority_id': user.id,
      },
    );

    return Map<String, dynamic>.from(result as Map);
  }
}