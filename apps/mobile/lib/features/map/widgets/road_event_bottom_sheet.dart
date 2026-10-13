import 'package:flutter/material.dart';

import '../../../core/localization/app_localizations_helpers.dart';
import '../../../l10n/app_localizations.dart';
import '../models/road_event.dart';

class RoadEventBottomSheet extends StatelessWidget {
  final RoadEvent event;
  final double distanceKm;

  const RoadEventBottomSheet({
    super.key,
    required this.event,
    required this.distanceKm,
  });

  String formattedDate(BuildContext context) {
    if (event.createdAt == null) {
      return AppLocalizations.of(context)!.unknownDate;
    }

    return event.createdAt!.toLocal().toString().substring(0, 16);
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey.shade300,
      child: const Icon(Icons.image, size: 70, color: Colors.black54),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imageUrl = event.imageUrl?.trim();
    final reporter = event.reporterEmail?.trim();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(event.description),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.warning_amber_rounded),
              title: Text(l10n.statusLabel),
              subtitle: Text(getLocalizedAlertStatus(context, event.status)),
            ),
            ListTile(
              leading: const Icon(Icons.place),
              title: Text(l10n.distance),
              subtitle: Text('${distanceKm.toStringAsFixed(2)} km'),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(l10n.reporter),
              subtitle: Text(
                reporter != null && reporter.isNotEmpty
                    ? reporter
                    : l10n.communityReporterFallback,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(l10n.reported),
              subtitle: Text(formattedDate(context)),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl == null || imageUrl.isEmpty
                  ? _imagePlaceholder()
                  : Image.network(
                      imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) {
                          return child;
                        }

                        return SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _imagePlaceholder();
                      },
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.navigationAvailableSoon)),
                      );
                    },
                    icon: const Icon(Icons.navigation),
                    label: Text(l10n.navigateButton),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.thanksForConfirming)),
                      );
                    },
                    icon: const Icon(Icons.check_circle),
                    label: Text(l10n.confirmButton),
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
