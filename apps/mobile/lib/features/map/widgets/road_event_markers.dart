import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/road_event.dart';
import 'road_event_bottom_sheet.dart';

class RoadEventMarkers extends StatelessWidget {
  const RoadEventMarkers({
    super.key,
    required this.events,
    required this.currentLocation,
  });

  final List<RoadEvent> events;
  final LatLng currentLocation;

  @override
  Widget build(BuildContext context) {
    debugPrint("");
    debugPrint("========== ROAD EVENT MARKERS ==========");
    debugPrint("Total Events : ${events.length}");

    for (final event in events) {
      debugPrint(
        "Marker -> ${event.title} : ${event.latitude}, ${event.longitude}",
      );
    }

    debugPrint("========================================");
    debugPrint("");

    return MarkerLayer(
      markers: events.map((event) {
        return Marker(
          // TEMPORARY TEST
          // We intentionally place every event at the user's current
          // location to verify that markers render correctly.
          point: currentLocation,

          width: 55,
          height: 55,

          child: GestureDetector(
            onTap: () {
              final distanceMeters =
                  Geolocator.distanceBetween(
                currentLocation.latitude,
                currentLocation.longitude,
                event.latitude,
                event.longitude,
              );

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => RoadEventBottomSheet(
                  event: event,
                  distanceKm: distanceMeters / 1000,
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}