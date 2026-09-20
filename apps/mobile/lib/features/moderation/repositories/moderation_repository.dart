import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/pending_report.dart';

class ModerationRepository {
  ModerationRepository()
      : _supabase = Supabase.instance.client;

  final SupabaseClient _supabase;

  Future<List<PendingReport>> fetchPendingReports() async {
    final response = await _supabase
        .from('incident_reports_map_view')
        .select()
        .eq('status', 'pending')
        .order('created_at', ascending: false);

    return response
        .map<PendingReport>(
          (json) => PendingReport.fromMap(json),
        )
        .toList();
  }

  Future<List<PendingReport>> fetchActiveReports() async {
    final response = await _supabase
        .from('active_incident_reports_view')
        .select()
        .order('created_at', ascending: false);

    return response
        .map<PendingReport>(
          (json) => PendingReport.fromMap(json),
        )
        .toList();
  }

  Future<String?> getImageUrl(String? imagePath) async {
    if (imagePath == null || imagePath.trim().isEmpty) {
      return null;
    }

    return _supabase.storage
        .from('incident-images')
        .createSignedUrl(
          imagePath,
          3600,
        );
  }

  Future<Map<String, dynamic>> approveReport(
    String reportId,
  ) async {
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

    return Map<String, dynamic>.from(
      result as Map,
    );
  }

  Future<Map<String, dynamic>> rejectReport(
    String reportId,
  ) async {
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

    return Map<String, dynamic>.from(
      result as Map,
    );
  }

  Future<Map<String, dynamic>> resolveReport(
    String reportId,
  ) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'You must be logged in to resolve an incident report.',
      );
    }

    final result = await _supabase.rpc(
      'resolve_incident_report',
      params: {
        'p_report_id': reportId,
        'p_authority_id': user.id,
      },
    );

    return Map<String, dynamic>.from(
      result as Map,
    );
  }
}