import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pending_report.dart';
import '../providers/active_incident_reports_provider.dart';
import '../providers/moderation_controller.dart';
import '../providers/pending_reports_provider.dart';
import '../repositories/moderation_repository.dart';

class ModerationPage extends ConsumerWidget {
  const ModerationPage({super.key});

  Future<bool> _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required bool destructive,
  }) async {
    final theme = Theme.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: destructive
                      ? theme.colorScheme.errorContainer
                      : theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  destructive
                      ? Icons.warning_amber_rounded
                      : Icons.help_outline_rounded,
                  color: destructive
                      ? theme.colorScheme.onErrorContainer
                      : theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(message),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: destructive
                  ? FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                    )
                  : null,
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
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
      destructive: false,
    );

    if (!confirmed || !context.mounted) {
      return;
    }

    try {
      await ref
          .read(moderationControllerProvider)
          .approveReport(report.id);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Incident report approved.',
          ),
        ),
      );

      ref.invalidate(pendingReportsProvider);
      ref.invalidate(activeIncidentReportsProvider);
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Approval failed: $error',
          ),
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
      destructive: true,
    );

    if (!confirmed || !context.mounted) {
      return;
    }

    try {
      await ref
          .read(moderationControllerProvider)
          .rejectReport(report.id);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Incident report rejected.',
          ),
        ),
      );

      ref.invalidate(pendingReportsProvider);
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Rejection failed: $error',
          ),
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
      destructive: false,
    );

    if (!confirmed || !context.mounted) {
      return;
    }

    try {
      await ref
          .read(moderationControllerProvider)
          .resolveReport(report.id);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Incident resolved and road restriction removed.',
          ),
        ),
      );

      ref.invalidate(activeIncidentReportsProvider);
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Resolution failed: $error',
          ),
        ),
      );
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();

    String twoDigits(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${local.day}/${local.month}/${local.year} '
        '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            child: Icon(
              icon,
              size: 17,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(
    BuildContext context, {
    required String status,
    required bool active,
  }) {
    final theme = Theme.of(context);

    final backgroundColor = active
        ? theme.colorScheme.errorContainer
        : theme.colorScheme.primaryContainer;

    final foregroundColor = active
        ? theme.colorScheme.onErrorContainer
        : theme.colorScheme.onPrimaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            active
                ? Icons.circle
                : Icons.verified_outlined,
            size: 12,
            color: foregroundColor,
          ),
          const SizedBox(width: 5),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentPhoto(
    BuildContext context,
    PendingReport report,
  ) {
    if (report.imagePath == null ||
        report.imagePath!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return FutureBuilder<String?>(
      future: ModerationRepository().getImageUrl(
        report.imagePath,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              color: theme
                  .colorScheme
                  .surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError ||
            snapshot.data == null) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme
                  .colorScheme
                  .errorContainer
                  .withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.broken_image_outlined,
                  color: theme
                      .colorScheme
                      .onErrorContainer,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Unable to load incident photo.',
                    style: TextStyle(
                      color: theme
                          .colorScheme
                          .onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            snapshot.data!,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
            loadingBuilder:
                (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }

              return Container(
                width: double.infinity,
                height: 220,
                color: theme
                    .colorScheme
                    .surfaceContainerHighest,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            errorBuilder:
                (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 180,
                color: theme
                    .colorScheme
                    .surfaceContainerHighest,
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    WidgetRef ref,
    PendingReport report, {
    required bool isActiveIncident,
  }) {
    final theme = Theme.of(context);

    final accentColor = isActiveIncident
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    final titleIcon = isActiveIncident
        ? Icons.warning_amber_rounded
        : Icons.report_problem_outlined;

    return Card(
      margin: const EdgeInsets.fromLTRB(
        12,
        4,
        12,
        8,
      ),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          14,
          14,
          14,
          12,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(
                      alpha: 0.10,
                    ),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Icon(
                    titleIcon,
                    size: 23,
                    color: accentColor,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.title,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 14,
                            color: theme
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              report.eventTypeName,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: theme
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                color: theme
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusBadge(
                  context,
                  status: report.status,
                  active: isActiveIncident,
                ),
              ],
            ),
            if (report.description.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.45),
                  borderRadius:
                      BorderRadius.circular(11),
                ),
                child: Text(
                  report.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
            if (report.imagePath != null &&
                report.imagePath!.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Incident Photo',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 9),
              _buildIncidentPhoto(
                context,
                report,
              ),
            ],
            const SizedBox(height: 12),
            Divider(
              height: 1,
              color: theme.dividerColor,
            ),
            const SizedBox(height: 12),
            Text(
              'Incident Details',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 9),
            _buildDetailItem(
              context,
              icon: Icons.access_time_rounded,
              label: 'Reported',
              value: _formatDateTime(
                report.createdAt,
              ),
            ),
            _buildDetailItem(
              context,
              icon: Icons.location_on_outlined,
              label: 'Location',
              value:
                  '${report.latitude.toStringAsFixed(5)}, '
                  '${report.longitude.toStringAsFixed(5)}',
            ),
            _buildDetailItem(
              context,
              icon: Icons.route_outlined,
              label: 'OSM Way',
              value:
                  report.osmWayId?.toString() ??
                      'Not assigned',
            ),
            if (report.reporterEmail != null &&
                report.reporterEmail!.trim().isNotEmpty)
              _buildDetailItem(
                context,
                icon: Icons.email_outlined,
                label: 'Reporter',
                value: report.reporterEmail!,
              ),
            const SizedBox(height: 5),
            if (!isActiveIncident)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _handleReject(
                          context,
                          ref,
                          report,
                        );
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 18,
                      ),
                      label: const Text('Reject'),
                      style:
                          OutlinedButton.styleFrom(
                        foregroundColor:
                            theme.colorScheme.error,
                        side: BorderSide(
                          color: theme
                              .colorScheme
                              .error
                              .withValues(
                                alpha: 0.5,
                              ),
                        ),
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 11,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        _handleApprove(
                          context,
                          ref,
                          report,
                        );
                      },
                      icon: const Icon(
                        Icons.check_rounded,
                        size: 18,
                      ),
                      label: const Text('Approve'),
                      style:
                          FilledButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 11,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (isActiveIncident)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    _handleResolve(
                      context,
                      ref,
                      report,
                    );
                  },
                  icon: const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                  ),
                  label: const Text(
                    'Resolve Incident',
                  ),
                  style: FilledButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 11,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required int count,
    required IconData icon,
    required bool active,
  }) {
    final theme = Theme.of(context);

    final color = active
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        8,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              size: 21,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            constraints:
                const BoxConstraints(minWidth: 30),
            padding:
                const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required bool active,
  }) {
    final theme = Theme.of(context);

    final icon = active
        ? Icons.check_circle_outline
        : Icons.inbox_outlined;

    final title = active
        ? 'No active incidents'
        : 'No pending reports';

    final subtitle = active
        ? 'All verified incidents are currently resolved.'
        : 'New community reports will appear here.';

    final color = active
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        16,
      ),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: theme
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.45),
          borderRadius:
              BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30,
              color: color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: theme
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context, {
    required String title,
    required Object error,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        12,
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme
              .colorScheme
              .errorContainer
              .withValues(alpha: 0.55),
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: theme
                  .colorScheme
                  .onErrorContainer,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme
                          .colorScheme
                          .onErrorContainer,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    error.toString(),
                    maxLines: 3,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme
                          .colorScheme
                          .onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        padding: EdgeInsets.all(22),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => _buildErrorState(
        context,
        title: 'Pending reports unavailable',
        error: error,
      ),
      data: (reports) {
        if (reports.isEmpty) {
          return _buildEmptyState(
            context,
            active: false,
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
        padding: EdgeInsets.all(22),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => _buildErrorState(
        context,
        title: 'Active incidents unavailable',
        error: error,
      ),
      data: (reports) {
        if (reports.isEmpty) {
          return _buildEmptyState(
            context,
            active: true,
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
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final pendingReports =
        ref.watch(pendingReportsProvider);

    final activeReports =
        ref.watch(activeIncidentReportsProvider);

    final pendingCount =
        pendingReports.maybeWhen(
      data: (reports) => reports.length,
      orElse: () => 0,
    );

    final activeCount =
        activeReports.maybeWhen(
      data: (reports) => reports.length,
      orElse: () => 0,
    );

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: theme
                    .colorScheme
                    .primaryContainer,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.admin_panel_settings_outlined,
                color: theme
                    .colorScheme
                    .onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 11),
            const Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Incident Moderation',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                  Text(
                    'Review community reports',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(
            pendingReportsProvider,
          );

          ref.invalidate(
            activeIncidentReportsProvider,
          );

          await Future.wait([
            ref.read(
              pendingReportsProvider.future,
            ),
            ref.read(
              activeIncidentReportsProvider.future,
            ),
          ]);
        },
        child: ListView(
          physics:
              const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            bottom: 24,
          ),
          children: [
            _buildSectionHeader(
              context,
              title: 'Pending Reports',
              subtitle:
                  'Awaiting authority review',
              count: pendingCount,
              icon:
                  Icons.pending_actions_rounded,
              active: false,
            ),
            _buildPendingSection(
              context,
              ref,
              pendingReports,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Divider(
                height: 24,
                color: theme.dividerColor,
              ),
            ),
            _buildSectionHeader(
              context,
              title: 'Active Incidents',
              subtitle:
                  'Currently affecting road routing',
              count: activeCount,
              icon:
                  Icons.warning_amber_rounded,
              active: true,
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