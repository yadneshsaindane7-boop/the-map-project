import 'package:flutter/material.dart';

import '../models/road_event.dart';

class RoadEventBottomSheet extends StatelessWidget {
  final RoadEvent event;
  final double distanceKm;

  const RoadEventBottomSheet({
    super.key,
    required this.event,
    required this.distanceKm,
  });

  String get formattedDate {
    if (event.createdAt == null) {
      return "Unknown";
    }

    return event.createdAt!
        .toLocal()
        .toString()
        .substring(0, 16);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 12),

            Text(event.description),

            const SizedBox(height: 24),

            ListTile(
              leading: const Icon(Icons.warning_amber_rounded),
              title: const Text("Status"),
              subtitle: Text(event.status),
            ),

            ListTile(
              leading: const Icon(Icons.place),
              title: const Text("Distance"),
              subtitle: Text(
                "${distanceKm.toStringAsFixed(2)} km",
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Reporter"),
              subtitle: Text(
                event.reportedBy ?? "Community",
              ),
            ),

            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text("Reported"),
              subtitle: Text(formattedDate),
            ),

            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: event.imageUrl == null
                    ? const Icon(
                        Icons.image,
                        size: 70,
                      )
                    : Image.network(
                        event.imageUrl!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Navigation will be available in v0.5.0",
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.navigation),
                    label: const Text("Navigate"),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Thanks for confirming this incident.",
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text("Confirm"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}