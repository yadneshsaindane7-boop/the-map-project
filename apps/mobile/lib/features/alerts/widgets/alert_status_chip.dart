import 'package:flutter/material.dart';

class AlertStatusChip extends StatelessWidget {
  const AlertStatusChip({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final normalized =
        status.toLowerCase();

    late final Color backgroundColor;
    late final Color foregroundColor;
    late final IconData icon;
    late final String label;

    switch (normalized) {
      case 'active':
        backgroundColor =
            theme.colorScheme.errorContainer;
        foregroundColor =
            theme.colorScheme.onErrorContainer;
        icon = Icons.circle;
        label = 'ACTIVE';
        break;

      case 'verified':
        backgroundColor =
            theme.colorScheme.tertiaryContainer;
        foregroundColor =
            theme
                .colorScheme
                .onTertiaryContainer;
        icon = Icons.verified_rounded;
        label = 'VERIFIED';
        break;

      case 'resolved':
      case 'completed':
        backgroundColor =
            theme.colorScheme.secondaryContainer;
        foregroundColor =
            theme
                .colorScheme
                .onSecondaryContainer;
        icon = Icons.check_circle_rounded;
        label = 'RESOLVED';
        break;

      default:
        backgroundColor =
            theme.colorScheme.surfaceContainerHighest;
        foregroundColor =
            theme.colorScheme.onSurfaceVariant;
        icon = Icons.info_outline_rounded;
        label = status.toUpperCase();
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: foregroundColor,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}