import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import 'profile_repository_provider.dart';

final profileProvider =
    FutureProvider<UserProfile>((ref) async {
  return ref
      .read(profileRepositoryProvider)
      .getProfile();
});