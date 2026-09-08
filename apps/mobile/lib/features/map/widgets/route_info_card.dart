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
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final routeState = ref.watch(routeProvider);
    final journeyState =
        ref.watch(journeyNavigationProvider);

    if (!routeState.hasRoute) {
      return const SizedBox.shrink();
    }

    final route = routeState.route!;

    return SafeArea(
      top: false,
      child: Card(
        margin: const EdgeInsets.fromLTRB(
          12,
          8,
          12,
          12,
        ),
        elevation: 12,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            18,
            16,
            18,
            18,
          ),
          child: journeyState.isNavigating
              ? _NavigationModeCard(
                  route: route,
                  remainingDistanceMeters:
                      journeyState
                              .remainingDistanceMeters ??
                          route.distance,
                  remainingDurationMillis:
                      journeyState
                              .remainingDurationMillis ??
                          route.time,
                  instruction:
                      journeyState.currentInstruction?.text,
                  instructionDistance:
                      journeyState
                          .currentInstruction
                          ?.distance,
                  onEndJourney: () {
                    ref
                        .read(
                          journeyNavigationProvider
                              .notifier,
                        )
                        .stopNavigation();
                  },
                )
              : _RoutePreviewCard(
                  route: route,
                  onStart: () {
                    ref
                        .read(
                          journeyNavigationProvider
                              .notifier,
                        )
                        .startNavigation(
                          initialDistanceMeters:
                              route.distance,
                          initialDurationMillis:
                              route.time,
                        );

                    unawaited(
                      NotificationService
                          .instance
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
    final theme = Theme.of(context);

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
              height: 48,
              color: theme.dividerColor,
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
          child: FilledButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.navigation),
            label: const Text(
              'START NAVIGATION',
            ),
            style: FilledButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavigationModeCard
    extends StatelessWidget {
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
    final theme = Theme.of(context);

    final instructionText =
        instruction?.trim().isNotEmpty == true
            ? instruction!
            : 'Continue on the current route';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor:
                  theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.navigation,
                color: theme
                    .colorScheme
                    .onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next instruction',
                    style: TextStyle(
                      color: theme
                          .colorScheme
                          .onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    instructionText,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (instructionDistance != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(
                        top: 5,
                      ),
                      child: Text(
                        'In ${_formatDistance(instructionDistance!)}',
                        style: TextStyle(
                          color: theme
                              .colorScheme
                              .onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'End journey',
              icon: const Icon(Icons.close),
              color: theme.colorScheme.error,
              onPressed: onEndJourney,
            ),
          ],
        ),

        const SizedBox(height: 14),

        Divider(
          color: theme.dividerColor,
        ),

        const SizedBox(height: 10),

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
              height: 48,
              color: theme.dividerColor,
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
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: theme
                .colorScheme
                .onSurfaceVariant,
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