import 'package:flutter/material.dart';

class MapFloatingControls extends StatelessWidget {
  const MapFloatingControls({
    super.key,
    required this.onLayersPressed,
    required this.onMyLocationPressed,
  });

  final VoidCallback onLayersPressed;
  final VoidCallback onMyLocationPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton.small(
          heroTag: 'layers',
          onPressed: onLayersPressed,
          child: const Icon(Icons.layers),
        ),
        const SizedBox(height: 12),
        FloatingActionButton.small(
          heroTag: 'location',
          onPressed: onMyLocationPressed,
          child: const Icon(Icons.my_location),
        ),
      ],
    );
  }
}