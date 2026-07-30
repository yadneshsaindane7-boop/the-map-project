import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/route_provider.dart';

class RoutePolyline extends ConsumerWidget {
  const RoutePolyline({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeState = ref.watch(routeProvider);

    if (!routeState.hasRoute) {
      return const SizedBox.shrink();
    }

    final route = routeState.route!;

    return PolylineLayer(
      polylines: [
        Polyline(
          points: route.points,
          strokeWidth: 6,
          color: Colors.blue,
        ),
      ],
    );
  }
}