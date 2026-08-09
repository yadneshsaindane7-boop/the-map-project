import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                )
              : _RoutePreviewCard(
                  route: route,
                  onStart: () {
                    ref
                        .read(
                          journeyNavigationProvider.notifier,
                        )
                        .startNavigation();
                  },
                ),
        ),
      ),
    );
  }
}

class _RoutePreviewCard extends StatelessWidget {
  final dynamic route;
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

class _NavigationModeCard extends ConsumerWidget {
  final dynamic route;

  const _NavigationModeCard({
    required this.route,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _InfoTile(
            icon: Icons.navigation,
            title: 'Remaining',
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
        const SizedBox(width: 12),
        IconButton(
          tooltip: 'End journey',
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
          onPressed: () {
            ref
                .read(
                  journeyNavigationProvider.notifier,
                )
                .stopNavigation();
          },
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