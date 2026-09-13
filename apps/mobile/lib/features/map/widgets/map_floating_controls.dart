import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Material(
      elevation: 6,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: l10n.mapLayers,
            onPressed: onLayersPressed,
            icon: const Icon(Icons.layers_outlined),
          ),
          Divider(
            height: 1,
            indent: 8,
            endIndent: 8,
            color: theme.dividerColor,
          ),
          IconButton(
            tooltip: l10n.myLocation,
            onPressed: onMyLocationPressed,
            icon: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}