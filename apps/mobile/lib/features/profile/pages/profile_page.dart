import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/moderation/pages/moderation_page.dart';
import '../../../features/settings/pages/about_page.dart';
import '../../../features/settings/pages/language_page.dart';
import '../../../features/settings/pages/notifications_page.dart';
import '../providers/profile_provider.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_achievements.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_stats_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final profile = ref.watch(profileProvider);
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
                18,
                10,
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: 28,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Your community activity',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: profile.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) {
          return _ProfileError(
            error: error,
            onRetry: () {
              ref.invalidate(profileProvider);
            },
          );
        },
        data: (user) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              16,
              18,
              16,
              28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileHeader(
                  profile: user,
                ),

                const SizedBox(height: 18),

                const _SectionHeading(
                  icon: Icons.insights_rounded,
                  title: 'Your Activity',
                  subtitle:
                      'Your contribution to the community',
                ),

                const SizedBox(height: 10),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.65,
                  children: [
                    ProfileStatsCard(
                      title: 'Reports',
                      value: user.totalReports.toString(),
                      icon: Icons.description_outlined,
                      iconColor: theme.colorScheme.primary,
                    ),
                    ProfileStatsCard(
                      title: 'Active',
                      value: user.activeReports.toString(),
                      icon: Icons.warning_amber_rounded,
                      iconColor: theme.colorScheme.tertiary,
                    ),
                    const ProfileStatsCard(
                      title: 'Reputation',
                      value: '95%',
                      icon: Icons.star_rounded,
                      iconColor: Colors.amber,
                    ),
                    const ProfileStatsCard(
                      title: 'Achievements',
                      value: '3',
                      icon: Icons.emoji_events_rounded,
                      iconColor: Colors.green,
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                const ProfileAchievements(),

                if (user.isAuthority) ...[
                  const SizedBox(height: 24),

                  const _SectionHeading(
                    icon:
                        Icons.admin_panel_settings_outlined,
                    title: 'Authority Tools',
                    subtitle:
                        'Tools available to authorized users',
                  ),

                  const SizedBox(height: 10),

                  ProfileMenuTile(
                    icon:
                        Icons.admin_panel_settings_outlined,
                    title:
                        'Moderate Incident Reports',
                    subtitle:
                        'Review, approve, or reject pending reports',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const ModerationPage(),
                        ),
                      );
                    },
                  ),
                ],

                const SizedBox(height: 24),

                const _SectionHeading(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  subtitle:
                      'Manage your app preferences',
                ),

                const SizedBox(height: 10),

                ProfileMenuTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle:
                      'Manage notification preferences',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const NotificationsPage(),
                      ),
                    );
                  },
                ),

                ProfileMenuTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const LanguagePage(),
                      ),
                    );
                  },
                ),

                ProfileMenuTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About',
                  subtitle:
                      'The Map Project v2.0',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const AboutPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                const LogoutButton(),

                const SizedBox(height: 12),

                Text(
                  'The Map Project • Nashik',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        theme.colorScheme.onSurfaceVariant,
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

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 21,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({
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
                color:
                    theme.colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_off_outlined,
                size: 38,
                color:
                    theme.colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Unable to load profile',
              textAlign: TextAlign.center,
              style:
                  theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We could not load your profile information.',
              textAlign: TextAlign.center,
              style:
                  theme.textTheme.bodyMedium?.copyWith(
                color:
                    theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
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