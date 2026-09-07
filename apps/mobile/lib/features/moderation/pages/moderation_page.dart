import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pending_report.dart';
import '../providers/active_incident_reports_provider.dart';
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

      ref.invalidate(pendingReportsProvider);
      ref.invalidate(activeIncidentReportsProvider);
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

      ref.invalidate(pendingReportsProvider);
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rejection failed: $error'),
        ),
      );
    }
  }

  Future<void> _handleResolve(
    BuildContext context,
    WidgetRef ref,
    PendingReport report,
  ) async {
    final confirmed = await _showConfirmationDialog(
      context,
      title: 'Resolve incident?',
      message:
          'Mark "${report.title}" as completed and remove its road restriction from active routing?',
      confirmLabel: 'Resolve',
    );

    if (!confirmed || !context.mounted) return;

    try {
      await ref
          .read(moderationControllerProvider)
          .resolveReport(report.id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Incident resolved and road restriction removed.',
          ),
        ),
      );

      ref.invalidate(activeIncidentReportsProvider);
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resolution failed: $error'),
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
    PendingReport report, {
    required bool isActiveIncident,
  }) {
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
                Icon(
                  isActiveIncident
                      ? Icons.warning_amber_rounded
                      : Icons.report_problem,
                  color: isActiveIncident ? Colors.red : Colors.orange,
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
            if (report.description.trim().isNotEmpty) ...[
              Text(
                report.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
            ],
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
              report.eventTypeName,
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
                if (!isActiveIncident) ...[
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
                if (isActiveIncident)
                  FilledButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Resolve Incident'),
                    onPressed: () => _handleResolve(
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

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required int count,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          CircleAvatar(
            radius: 14,
            child: Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<PendingReport>> pendingReports,
  ) {
    return pendingReports.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Failed to load pending reports:\n$error',
        ),
      ),
      data: (reports) {
        if (reports.isEmpty) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text('No pending reports.'),
          );
        }

        return Column(
          children: [
            for (final report in reports)
              _buildReportCard(
                context,
                ref,
                report,
                isActiveIncident: false,
              ),
          ],
        );
      },
    );
  }

  Widget _buildActiveSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<PendingReport>> activeReports,
  ) {
    return activeReports.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Failed to load active incidents:\n$error',
        ),
      ),
      data: (reports) {
        if (reports.isEmpty) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text('No active incidents.'),
          );
        }

        return Column(
          children: [
            for (final report in reports)
              _buildReportCard(
                context,
                ref,
                report,
                isActiveIncident: true,
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingReports = ref.watch(pendingReportsProvider);
    final activeReports = ref.watch(activeIncidentReportsProvider);

    final pendingCount = pendingReports.maybeWhen(
      data: (reports) => reports.length,
      orElse: () => 0,
    );

    final activeCount = activeReports.maybeWhen(
      data: (reports) => reports.length,
      orElse: () => 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incident Moderation'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(pendingReportsProvider);
          ref.invalidate(activeIncidentReportsProvider);

          await Future.wait([
            ref.read(pendingReportsProvider.future),
            ref.read(activeIncidentReportsProvider.future),
          ]);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            _buildSectionHeader(
              context,
              title: 'Pending Reports',
              count: pendingCount,
              icon: Icons.pending_actions,
            ),
            _buildPendingSection(
              context,
              ref,
              pendingReports,
            ),
            const Divider(height: 32),
            _buildSectionHeader(
              context,
              title: 'Active Incidents',
              count: activeCount,
              icon: Icons.warning_amber_rounded,
            ),
            _buildActiveSection(
              context,
              ref,
              activeReports,
            ),
          ],
        ),
      ),
    );
  }
}