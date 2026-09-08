import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() =>
      _NotificationsPageState();
}

class _NotificationsPageState
    extends State<NotificationsPage> {
  bool pushNotifications = true;
  bool nearbyAlerts = true;
  bool routeUpdates = true;
  bool communityReports = true;

  void _setAllNotifications(bool value) {
    setState(() {
      pushNotifications = value;
      nearbyAlerts = value;
      routeUpdates = value;
      communityReports = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stay informed',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Notification settings',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          14,
          16,
          28,
        ),
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            child: SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              secondary: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(
                'Push Notifications',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  'Receive important notifications from The Map Project.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              value: pushNotifications,
              onChanged: _setAllNotifications,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'Notification Types',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            child: Column(
              children: [
                _NotificationSettingTile(
                  icon: Icons.traffic_outlined,
                  title: 'Nearby Road Alerts',
                  description:
                      'Get alerts about incidents and road conditions near you.',
                  value: nearbyAlerts,
                  enabled: pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      nearbyAlerts = value;
                    });
                  },
                ),
                const _SettingDivider(),
                _NotificationSettingTile(
                  icon: Icons.alt_route_rounded,
                  title: 'Route Updates',
                  description:
                      'Be notified when your active route needs to change.',
                  value: routeUpdates,
                  enabled: pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      routeUpdates = value;
                    });
                  },
                ),
                const _SettingDivider(),
                _NotificationSettingTile(
                  icon: Icons.groups_outlined,
                  title: 'Community Reports',
                  description:
                      'Receive updates related to community-reported incidents.',
                  value: communityReports,
                  enabled: pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      communityReports = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colorScheme.outlineVariant,
              ),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Notification preferences currently apply to this '
                    'session. Persistent notification preferences will '
                    'be added in a future update.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Center(
            child: Text(
              'The Map Project • Notification Settings',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSettingTile extends StatelessWidget {
  const _NotificationSettingTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final iconColor = enabled
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant.withValues(
            alpha: 0.5,
          );

    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),
      secondary: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: enabled
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: enabled
              ? colorScheme.onSurface
              : colorScheme.onSurface.withValues(
                  alpha: 0.5,
                ),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: enabled
                ? colorScheme.onSurfaceVariant
                : colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.5,
                  ),
            height: 1.35,
          ),
        ),
      ),
      value: value,
      onChanged: enabled ? onChanged : null,
    );
  }
}

class _SettingDivider extends StatelessWidget {
  const _SettingDivider();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Divider(
      height: 1,
      indent: 68,
      endIndent: 16,
      color: theme.dividerColor,
    );
  }
}