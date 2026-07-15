import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../providers/road_event_provider.dart';

class RoadEventMarkers extends ConsumerWidget {
  const RoadEventMarkers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadEvents = ref.watch(roadEventsProvider);

    return roadEvents.when(
      loading: () => const MarkerLayer(
        markers: [],
      ),
      error: (error, stackTrace) => const MarkerLayer(
        markers: [],
      ),
      data: (events) {
        return MarkerLayer(
          markers: events.map((event) {
            return Marker(
              point: LatLng(
                event.latitude,
                event.longitude,
              ),
              width: 45,
              height: 45,
              child: Tooltip(
                message: event.title,
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 38,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}