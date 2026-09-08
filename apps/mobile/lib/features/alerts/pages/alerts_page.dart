import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/alerts_provider.dart';
import '../widgets/alert_card.dart';
import '../widgets/empty_alerts.dart';

class AlertsPage extends ConsumerWidget {
  const AlertsPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final alerts = ref.watch(alertsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(82),
        child: Material(
          elevation: 2,
          color: theme.colorScheme.surface,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                18,
                8,
                12,
                10,
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme
                          .colorScheme
                          .primaryContainer,
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.notifications_active_rounded,
                      size: 27,
                      color: theme
                          .colorScheme
                          .onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Traffic Alerts',
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: theme
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Stay informed about incidents nearby',
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
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: 'Refresh alerts',
                    onPressed: () {
                      ref.invalidate(
                        alertsProvider,
                      );
                    },
                    icon: const Icon(
                      Icons.refresh_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: alerts.when(
        loading: () => const _AlertsLoading(),

        error: (error, stackTrace) {
          return _AlertsError(
            error: error,
            onRetry: () {
              ref.invalidate(
                alertsProvider,
              );
            },
          );
        },

        data: (data) {
          if (data.isEmpty) {
            return const EmptyAlerts();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                alertsProvider,
              );

              await ref.read(
                alertsProvider.future,
              );
            },
            child: ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                18,
                16,
                28,
              ),
              children: [
                _AlertsSummary(
                  count: data.length,
                ),
                const SizedBox(height: 14),
                ...data.map(
                  (alert) => AlertCard(
                    alert: alert,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AlertsSummary extends StatelessWidget {
  const _AlertsSummary({
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final text =
        count == 1
            ? '1 active alert'
            : '$count active alerts';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: theme
            .colorScheme
            .surfaceContainerHighest,
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            'Updated live',
            style: theme
                .textTheme
                .labelMedium
                ?.copyWith(
              color: theme
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertsLoading
    extends StatelessWidget {
  const _AlertsLoading();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading traffic alerts...',
            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color: theme
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertsError
    extends StatelessWidget {
  const _AlertsError({
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: theme
                    .colorScheme
                    .errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons
                    .cloud_off_rounded,
                size: 38,
                color: theme
                    .colorScheme
                    .onErrorContainer,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Unable to load alerts',
              textAlign: TextAlign.center,
              style: theme
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Something went wrong while loading '
              'the latest traffic alerts.',
              textAlign: TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: theme
                    .colorScheme
                    .onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              maxLines: 3,
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
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}