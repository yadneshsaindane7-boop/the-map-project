import 'package:supabase_flutter/supabase_flutter.dart';

import 'user_service.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  final UserService _userService = UserService();

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter://login-callback',
    );
  }

  Future<void> syncLoggedInUser() async {
    await _userService.syncUser();
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  bool get isLoggedIn => currentUser != null;

  Stream<AuthState> get authState => _client.auth.onAuthStateChange;
}