import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../providers/location_provider.dart';
import '../providers/road_event_provider.dart';
import 'road_event_bottom_sheet.dart';

class RoadEventMarkers extends ConsumerWidget {
  const RoadEventMarkers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roadEvents = ref.watch(roadEventsProvider);
    final currentLocation = ref.watch(currentLocationProvider);

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
              width: 50,
              height: 50,
              child: GestureDetector(
                onTap: () {
                  currentLocation.whenData((position) {
                    final distanceMeters = Geolocator.distanceBetween(
                      position.latitude,
                      position.longitude,
                      event.latitude,
                      event.longitude,
                    );

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => RoadEventBottomSheet(
                        event: event,
                        distanceKm: distanceMeters / 1000,
                      ),
                    );
                  });
                },
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