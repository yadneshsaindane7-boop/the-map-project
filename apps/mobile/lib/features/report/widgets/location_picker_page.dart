import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/map/map_styles.dart';
import '../../../core/map/map_tile_provider.dart';
import '../../../l10n/app_localizations.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({
    super.key,
    required this.initialLocation,
  });

  final LatLng initialLocation;

  @override
  State<LocationPickerPage> createState() =>
      _LocationPickerPageState();
}

class _LocationPickerPageState
    extends State<LocationPickerPage> {
  late final MapController _mapController;

  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    _selectedLocation = widget.initialLocation;
  }

  void _resetLocation() {
    setState(() {
      _selectedLocation = widget.initialLocation;
    });

    _mapController.move(
      widget.initialLocation,
      17,
    );
  }

  void _useLocation() {
    Navigator.pop(
      context,
      _selectedLocation,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Map
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: widget.initialLocation,
                initialZoom: 17,
                onTap: (_, point) {
                  setState(() {
                    _selectedLocation = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: MapTileProvider.getTileUrl(
                    MapStyle.streets,
                  ),
                  userAgentPackageName:
                      'com.themapproject.mobile',
                ),

                if (_selectedLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation!,
                        width: 56,
                        height: 64,
                        alignment: Alignment.topCenter,
                        child: Icon(
                          Icons.location_on_rounded,
                          color: colorScheme.error,
                          size: 52,
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            // Top bar
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Material(
                elevation: 6,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(16),
                color: colorScheme.surface,
                child: SizedBox(
                  height: 58,
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: l10n.back,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          l10n.chooseIncidentLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.resetLocation,
                        onPressed: _resetLocation,
                        icon: const Icon(
                          Icons.my_location_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Map instruction
            Positioned(
              top: 82,
              left: 42,
              right: 42,
              child: IgnorePointer(
                child: Center(
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(12),
                    color: colorScheme.surface.withValues(
                      alpha: 0.94,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              l10n.tapMapToSelectLocation,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Selected location confirmation
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Material(
                elevation: 8,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(20),
                color: colorScheme.surface,
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    16,
                    18,
                    14,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.location_on_rounded,
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.incidentLocation,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  l10n.selectedPointAttached,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color:
                                        colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton.icon(
                          onPressed: _selectedLocation == null
                              ? null
                              : _useLocation,
                          icon: const Icon(
                            Icons.check_rounded,
                          ),
                          label: Text(
                            l10n.useThisLocation,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}