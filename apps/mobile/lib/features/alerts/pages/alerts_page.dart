import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/alerts_provider.dart';
import '../widgets/alert_card.dart';
import '../widgets/empty_alerts.dart';

class AlertsPage extends ConsumerWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Alerts'),
        centerTitle: true,
      ),
      body: alerts.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 72,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () {
                    // Rebuilds the provider.
                    ref.invalidate(alertsProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (data) {
          if (data.isEmpty) {
            return const EmptyAlerts();
          }

          return RefreshIndicator(
            onRefresh: () async {
              // Refresh and wait for the new value.
              final future = ref.refresh(alertsProvider.future);
              await future;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return AlertCard(
                  alert: data[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}