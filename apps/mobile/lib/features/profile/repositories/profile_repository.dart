import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';

class ProfileRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<UserProfile> getProfile() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in.');
    }

    final userData = await _client
        .from('users')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    final totalReports = await _client
        .from('road_events')
        .count(CountOption.exact)
        .eq('reported_by', user.id);

    final activeReports = await _client
        .from('road_events')
        .count(CountOption.exact)
        .eq('reported_by', user.id)
        .eq('status', 'active');

    return UserProfile(
      id: user.id,
      email: user.email ?? '',
      fullName: user.userMetadata?['full_name'] as String?,
      role: userData?['role']?.toString() ?? 'user',
      totalReports: totalReports,
      activeReports: activeReports,
      approvedReports: 0,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}