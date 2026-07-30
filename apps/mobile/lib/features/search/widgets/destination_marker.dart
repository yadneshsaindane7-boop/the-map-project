import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DestinationMarker extends StatelessWidget {
  const DestinationMarker({
    super.key,
    required this.position,
  });

  final LatLng position;

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        Marker(
          point: position,
          width: 60,
          height: 60,
          alignment: Alignment.topCenter,
          child: const Icon(
            Icons.location_pin,
            size: 52,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}