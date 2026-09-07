import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/notification_service.dart';
import '../../navigation/models/route_model.dart';
import '../../navigation/providers/navigation_provider.dart';
import '../../navigation/providers/route_provider.dart';

class RouteInfoCard extends ConsumerWidget {
  const RouteInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeState = ref.watch(routeProvider);
    final journeyState = ref.watch(journeyNavigationProvider);

    if (!routeState.hasRoute) {
      return const SizedBox.shrink();
    }

    final route = routeState.route!;

    return SafeArea(
      top: false,
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: journeyState.isNavigating
              ? _NavigationModeCard(
                  route: route,
                  remainingDistanceMeters:
                      journeyState.remainingDistanceMeters ??
                          route.distance,
                  remainingDurationMillis:
                      journeyState.remainingDurationMillis ??
                          route.time,
                  instruction: journeyState.currentInstruction?.text,
                  instructionDistance:
                      journeyState.currentInstruction?.distance,
                  onEndJourney: () {
                    ref
                        .read(
                          journeyNavigationProvider.notifier,
                        )
                        .stopNavigation();
                  },
                )
              : _RoutePreviewCard(
                  route: route,
                  onStart: () {
                    ref
                        .read(
                          journeyNavigationProvider.notifier,
                        )
                        .startNavigation(
                          initialDistanceMeters:
                              route.distance,
                          initialDurationMillis:
                              route.time,
                        );

                    unawaited(
                      NotificationService.instance
                          .showJourneyStarted(),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _RoutePreviewCard extends StatelessWidget {
  final RouteModel route;
  final VoidCallback onStart;

  const _RoutePreviewCard({
    required this.route,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _InfoTile(
                icon: Icons.route,
                title: 'Distance',
                value:
                    '${route.distanceKm.toStringAsFixed(1)} km',
              ),
            ),
            Container(
              width: 1,
              height: 45,
              color: Colors.grey.shade300,
            ),
            Expanded(
              child: _InfoTile(
                icon: Icons.access_time,
                title: 'ETA',
                value:
                    '${route.durationMinutes.round()} min',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.navigation),
            label: const Text('START'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavigationModeCard extends StatelessWidget {
  final RouteModel route;
  final double remainingDistanceMeters;
  final int remainingDurationMillis;
  final String? instruction;
  final double? instructionDistance;
  final VoidCallback onEndJourney;

  const _NavigationModeCard({
    required this.route,
    required this.remainingDistanceMeters,
    required this.remainingDurationMillis,
    required this.instruction,
    required this.instructionDistance,
    required this.onEndJourney,
  });

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }

    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  String _formatDuration(int milliseconds) {
    final totalMinutes =
        (milliseconds / 60000).ceil();

    if (totalMinutes <= 1) {
      return '1 min';
    }

    if (totalMinutes < 60) {
      return '$totalMinutes min';
    }

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (minutes == 0) {
      return '$hours hr';
    }

    return '$hours hr $minutes min';
  }

  @override
  Widget build(BuildContext context) {
    final instructionText =
        instruction?.trim().isNotEmpty == true
            ? instruction!
            : 'Continue on the current route';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(
              Icons.navigation,
              size: 30,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                instructionText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              tooltip: 'End journey',
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              ),
              onPressed: onEndJourney,
            ),
          ],
        ),

        if (instructionDistance != null) ...[
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 42),
              child: Text(
                'In ${_formatDistance(instructionDistance!)}',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],

        const SizedBox(height: 16),
        Divider(color: Colors.grey.shade300),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _InfoTile(
                icon: Icons.route,
                title: 'Remaining',
                value: _formatDistance(
                  remainingDistanceMeters,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 45,
              color: Colors.grey.shade300,
            ),
            Expanded(
              child: _InfoTile(
                icon: Icons.access_time,
                title: 'ETA',
                value: _formatDuration(
                  remainingDurationMillis,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}