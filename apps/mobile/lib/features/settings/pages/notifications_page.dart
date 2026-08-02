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
        ],
      ),
    );
  }
}