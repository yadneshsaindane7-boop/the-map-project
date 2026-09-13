import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations_helpers.dart';
import '../../../l10n/app_localizations.dart';
import '../../map/providers/selected_map_location_provider.dart';
import '../../navigation/providers/navigation_provider.dart';
import '../models/traffic_alert.dart';
import 'alert_status_chip.dart';

class AlertCard extends ConsumerWidget {
  const AlertCard({
    super.key,
    required this.alert,
  });

  final TrafficAlert alert;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final status =
        alert.status.toLowerCase();

    final isActive =
        status == 'active' ||
        status == 'verified';

    return Card(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          15,
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
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isActive
                        ? theme
                            .colorScheme
                            .errorContainer
                        : theme
                            .colorScheme
                            .surfaceContainerHighest,
                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                  child: Icon(
                    Icons
                        .warning_amber_rounded,
                    color: isActive
                        ? theme
                            .colorScheme
                            .onErrorContainer
                        : theme
                            .colorScheme
                            .onSurfaceVariant,
                    size: 25,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.title,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style: theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons
                                .location_on_outlined,
                            size: 15,
                            color: theme
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Nashik',
                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
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

                AlertStatusChip(
                  status: alert.status,
                ),
              ],
            ),

            if (alert.description
                .trim()
                .isNotEmpty) ...[
              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme
                      .colorScheme
                      .surfaceContainerHighest,
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: Text(
                  alert.description,
                  maxLines: 3,
                  overflow:
                      TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    height: 1.35,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 14),

            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 17,
                  color: theme
                      .colorScheme
                      .onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  formatTimeAgo(context, alert.createdAt),
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons
                      .verified_outlined,
                  size: 16,
                  color: theme
                      .colorScheme
                      .primary,
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.communityVerified,
                  style: theme
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                    color: theme
                        .colorScheme
                        .primary,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () {
                  ref
                      .read(
                        selectedMapLocationProvider
                            .notifier,
                      )
                      .selectLocation(
                        latitude:
                            alert.latitude,
                        longitude:
                            alert.longitude,
                      );

                  ref
                      .read(
                        navigationProvider
                            .notifier,
                      )
                      .changeTab(0);
                },
                icon: const Icon(
                  Icons.map_outlined,
                ),
                label: Text(
                  l10n.viewOnMap,
                ),
                style:
                    FilledButton.styleFrom(
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}