import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../providers/route_provider.dart';

class RoutePolyline extends ConsumerWidget {
  const RoutePolyline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeState = ref.watch(routeProvider);

    if (!routeState.hasRoute) {
      return PolylineLayer<LatLng>(
        polylines: const [],
      );
    }

    final route = routeState.route!;

    if (route.points.isEmpty) {
      return PolylineLayer<LatLng>(
        polylines: const [],
      );
    }

    return PolylineLayer<LatLng>(
      polylines: [
        Polyline<LatLng>(
          points: route.points,
          strokeWidth: 6,
          color: Colors.blue,
        ),
      ],
    );
  }
}