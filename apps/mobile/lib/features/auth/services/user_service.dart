import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> syncUser() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      debugPrint('❌ No authenticated user');
      return;
    }

    debugPrint('✅ Syncing user: ${user.email}');

    final existing = await _client
        .from('users')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    final metadata = user.userMetadata ?? {};

    final fullName =
        metadata['full_name'] ??
        metadata['name'] ??
        'Unknown User';

    final avatarUrl =
        metadata['avatar_url'] ??
        metadata['picture'];

    if (existing == null) {
      debugPrint('🟢 Creating profile...');

      await _client.from('users').insert({
        'id': user.id,
        'full_name': fullName,
        'email': user.email,
        'avatar_url': avatarUrl,
        'last_login_at': DateTime.now().toIso8601String(),
      });

      debugPrint('✅ Profile created');
    } else {
      debugPrint('🟡 Updating profile...');

      await _client
          .from('users')
          .update({
            'last_login_at': DateTime.now().toIso8601String(),
            'avatar_url': avatarUrl,
          })
          .eq('id', user.id);

      debugPrint('✅ Profile updated');
    }
  }
}