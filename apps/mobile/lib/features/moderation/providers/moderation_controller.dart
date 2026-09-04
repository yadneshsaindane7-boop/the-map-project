import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'moderation_repository_provider.dart';
import 'pending_reports_provider.dart';

final moderationControllerProvider = Provider<ModerationController>((ref) {
  return ModerationController(ref);
});

class ModerationController {
  ModerationController(this._ref);

  final Ref _ref;

  Future<void> approveReport(String reportId) async {
    final repository = _ref.read(moderationRepositoryProvider);

    final result = await repository.approveReport(reportId);

    if (result['success'] != true) {
      throw Exception(
        result['message'] ?? 'Failed to approve the incident report.',
      );
    }

    _ref.invalidate(pendingReportsProvider);
  }

  Future<void> rejectReport(String reportId) async {
    final repository = _ref.read(moderationRepositoryProvider);

    final result = await repository.rejectReport(reportId);

    if (result['success'] != true) {
      throw Exception(
        result['message'] ?? 'Failed to reject the incident report.',
      );
    }

    _ref.invalidate(pendingReportsProvider);
  }
}
