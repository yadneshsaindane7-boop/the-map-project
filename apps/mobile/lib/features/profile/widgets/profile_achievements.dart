import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class ProfileAchievements extends StatelessWidget {
  const ProfileAchievements({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme
                        .colorScheme
                        .primaryContainer,
                    borderRadius:
                        BorderRadius.circular(11),
                  ),
                  child: Icon(
                    Icons
                        .emoji_events_outlined,
                    size: 22,
                    color: theme
                        .colorScheme
                        .onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.achievementsLabel,
                        style: theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.communityMilestones,
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

            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _AchievementChip(
                  icon:
                      Icons.emoji_events_rounded,
                  color: Colors.amber,
                  label: l10n.achievementFirstReport,
                ),
                _AchievementChip(
                  icon:
                      Icons.shield_rounded,
                  color: Colors.green,
                  label: l10n.achievementRoadGuardian,
                ),
                _AchievementChip(
                  icon: Icons.groups_rounded,
                  color: Colors.blue,
                  label: l10n.achievementCommunityHelper,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementChip
    extends StatelessWidget {
  const _AchievementChip({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: theme
            .colorScheme
            .surfaceContainerHighest,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(
            alpha: 0.22,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.13,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: theme
                .textTheme
                .labelMedium
                ?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}