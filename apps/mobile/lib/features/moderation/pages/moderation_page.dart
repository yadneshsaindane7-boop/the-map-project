import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pending_report.dart';
import '../providers/moderation_controller.dart';
import '../providers/pending_reports_provider.dart';

class ModerationPage extends ConsumerWidget {
  const ModerationPage({super.key});

  Future<bool> _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _handleApprove(
    BuildContext context,
    WidgetRef ref,
    PendingReport report,
  ) async {
    final confirmed = await _showConfirmationDialog(
      context,
      title: 'Approve incident?',
      message:
          'Approve "${report.title}" and make this incident available to the routing system?',
      confirmLabel: 'Approve',
    );

    if (!confirmed || !context.mounted) return;

    try {
      await ref
          .read(moderationControllerProvider)
          .approveReport(report.id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incident report approved.'),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Approval failed: $error'),
        ),
      );
    }
  }

  Future<void> _handleReject(
    BuildContext context,
    WidgetRef ref,
    PendingReport report,
  ) async {
    final confirmed = await _showConfirmationDialog(
      context,
      title: 'Reject incident?',
      message:
          'Reject "${report.title}"? This report will not be activated for routing.',
      confirmLabel: 'Reject',
    );

    if (!confirmed || !context.mounted) return;

    try {
      await ref
          .read(moderationControllerProvider)
          .rejectReport(report.id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incident report rejected.'),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rejection failed: $error'),
        ),
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();

    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${local.day}/${local.month}/${local.year} '
        '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    WidgetRef ref,
    PendingReport report,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.report_problem,
                  color: Colors.orange,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    report.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              report.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'Incident Details',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Status',
              report.status,
              icon: Icons.pending_actions,
            ),
            _buildDetailRow(
              'Event Type',
              report.eventTypeId,
              icon: Icons.category_outlined,
            ),
            _buildDetailRow(
              'Reported',
              _formatDateTime(report.createdAt),
              icon: Icons.access_time,
            ),
            _buildDetailRow(
              'Location',
              '${report.latitude.toStringAsFixed(6)}, '
                  '${report.longitude.toStringAsFixed(6)}',
              icon: Icons.location_on_outlined,
            ),
            _buildDetailRow(
              'OSM Way',
              report.osmWayId?.toString() ?? 'Not assigned',
              icon: Icons.route,
            ),
            if (report.userId != null)
              _buildDetailRow(
                'Reporter',
                report.userId!,
                icon: Icons.person_outline,
              ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.close),
                  label: const Text('Reject'),
                  onPressed: () => _handleReject(
                    context,
                    ref,
                    report,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Approve'),
                  onPressed: () => _handleApprove(
                    context,
                    ref,
                    report,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingReports = ref.watch(pendingReportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Reports'),
      ),
      body: pendingReports.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (reports) {
          if (reports.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(pendingReportsProvider);
                await ref.read(pendingReportsProvider.future);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 220),
                  Center(
                    child: Text('No pending reports'),
                  ),
                ],
              ),
            );
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
                return _buildReportCard(
                  context,
                  ref,
                  reports[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}