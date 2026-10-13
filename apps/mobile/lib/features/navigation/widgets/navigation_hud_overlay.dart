import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../navigation/models/maneuver_type.dart';
import '../../navigation/providers/navigation_provider.dart';

class NavigationHudOverlay extends ConsumerWidget {
const NavigationHudOverlay({super.key});

@override
Widget build(BuildContext context, WidgetRef ref) {
final journey = ref.watch(journeyNavigationProvider);

if (!journey.isNavigating || journey.hasArrived) {
  return const SizedBox.shrink();
}

final instruction = journey.currentInstruction;
if (instruction == null) return const SizedBox.shrink();

final maneuverType = ManeuverType.values.firstWhere(
  (m) => m.sign == instruction.sign,
  orElse: () => ManeuverType.continueStraight,
);

final distanceText = journey.remainingDistanceMeters != null
    ? _formatDistance(journey.remainingDistanceMeters!)
    : null;

final colorScheme = Theme.of(context).colorScheme;

return SafeArea(
  bottom: false,
  child: Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    child: Material(
      color: colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(18),
      elevation: 8,
      shadowColor: Colors.black38,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              maneuverType.icon,
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _displayText(instruction.text),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  if (distanceText != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      distanceText,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);

}

String _displayText(String key) {
return switch (key) {
'turn_right' => 'Turn Right',
'turn_left' => 'Turn Left',
'slight_right' => 'Bear Right',
'slight_left' => 'Bear Left',
'sharp_right' => 'Sharp Right',
'sharp_left' => 'Sharp Left',
'u_turn' => 'Make a U-Turn',
'continue_straight' => 'Continue Straight',
'arrived' => 'Destination Reached',
_ => 'Continue',
};
}

String _formatDistance(double meters) {
if (meters < 1000) return '${meters.round()} m';
return '${(meters / 1000).toStringAsFixed(1)} km';
}
}
