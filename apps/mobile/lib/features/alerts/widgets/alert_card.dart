import 'package:flutter/material.dart';

import '../models/traffic_alert.dart';
import 'alert_status_chip.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.alert,
  });

  final TrafficAlert alert;

  String get timeAgo {
    final difference =
        DateTime.now().difference(alert.createdAt);

    if (difference.inMinutes < 1) {
      return "Just now";
    }

    if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    }

    if (difference.inHours < 24) {
      return "${difference.inHours} hr ago";
    }

    return "${difference.inDays} day ago";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    alert.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight:
                              FontWeight.bold,
                        ),
                  ),
                ),

                AlertStatusChip(
                  status: alert.status,
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(alert.description),

            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 18,
                ),

                const SizedBox(width: 6),

                Text(timeAgo),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Map integration coming soon.",
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.map,
                ),
                label: const Text(
                  "View on Map",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}