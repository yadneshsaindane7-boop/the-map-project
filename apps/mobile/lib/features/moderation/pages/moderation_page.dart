import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pending_reports_provider.dart';

class ModerationPage extends ConsumerWidget {
  const ModerationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingReports = ref.watch(
      pendingReportsProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pending Reports',
        ),
      ),
      body: pendingReports.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text(error.toString()),
        ),
        data: (reports) {
          if (reports.isEmpty) {
            return const Center(
              child: Text(
                'No pending reports',
              ),
            );
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.report_problem,
                    color: Colors.orange,
                  ),
                  title: Text(report.title),
                  subtitle: Text(
                    report.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}