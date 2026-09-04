import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/moderation_controller.dart';
import '../providers/pending_reports_provider.dart';

class ModerationPage extends ConsumerWidget {
  const ModerationPage({super.key});

  Future<void> _handleApprove(
    BuildContext context,
    WidgetRef ref,
    String reportId,
  ) async {
    try {
      await ref.read(moderationControllerProvider).approveReport(reportId);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incident report approved.')),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Approval failed: $error')));
    }
  }

  Future<void> _handleReject(
    BuildContext context,
    WidgetRef ref,
    String reportId,
  ) async {
    try {
      await ref.read(moderationControllerProvider).rejectReport(reportId);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incident report rejected.')),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Rejection failed: $error')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingReports = ref.watch(pendingReportsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pending Reports')),
      body: pendingReports.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (reports) {
          if (reports.isEmpty) {
            return const Center(child: Text('No pending reports'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(pendingReportsProvider);

              await ref.read(pendingReportsProvider.future);
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.report_problem,
                            color: Colors.orange,
                          ),
                          title: Text(
                            report.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              report.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.close),
                              label: const Text('Reject'),
                              onPressed: () =>
                                  _handleReject(context, ref, report.id),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              icon: const Icon(Icons.check),
                              label: const Text('Approve'),
                              onPressed: () =>
                                  _handleApprove(context, ref, report.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
