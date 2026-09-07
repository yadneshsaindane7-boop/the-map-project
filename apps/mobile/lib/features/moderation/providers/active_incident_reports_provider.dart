import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pending_report.dart';
import 'moderation_repository_provider.dart';

final activeIncidentReportsProvider =
    FutureProvider<List<PendingReport>>((ref) async {
  final repository = ref.read(
    moderationRepositoryProvider,
  );

  return repository.fetchActiveReports();
});