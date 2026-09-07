import 'package:flutter/material.dart';

import '../../../core/services/notification_service.dart';

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

  Future<void> _sendTestNotification() async {
    if (!pushNotifications) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Push Notifications are turned off.',
          ),
        ),
      );

      return;
    }

    await NotificationService.instance.showTestNotification();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Test notification sent.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text(
              'Push Notifications',
            ),
            subtitle: const Text(
              'Receive important notifications.',
            ),
            value: pushNotifications,
            onChanged: (value) {
              setState(() {
                pushNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text(
              'Nearby Road Alerts',
            ),
            subtitle: const Text(
              'Alerts for incidents near you.',
            ),
            value: nearbyAlerts,
            onChanged: (value) {
              setState(() {
                nearbyAlerts = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text(
              'Route Updates',
            ),
            subtitle: const Text(
              'Notify when your route changes.',
            ),
            value: routeUpdates,
            onChanged: (value) {
              setState(() {
                routeUpdates = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text(
              'Community Reports',
            ),
            subtitle: const Text(
              'Receive new community reports.',
            ),
            value: communityReports,
            onChanged: (value) {
              setState(() {
                communityReports = value;
              });
            },
          ),
          const Divider(
            height: 32,
          ),
          ListTile(
            leading: const Icon(
              Icons.notifications_active_outlined,
            ),
            title: const Text(
              'Test Notifications',
            ),
            subtitle: const Text(
              'Send a test notification to this device.',
            ),
            trailing: FilledButton(
              onPressed: _sendTestNotification,
              child: const Text(
                'Test',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
