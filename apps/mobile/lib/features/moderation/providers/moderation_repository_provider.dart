import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/moderation_repository.dart';

final moderationRepositoryProvider =
    Provider<ModerationRepository>((ref) {
  return ModerationRepository();
});