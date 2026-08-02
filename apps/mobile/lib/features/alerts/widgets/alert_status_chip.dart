import 'package:flutter/material.dart';

class AlertStatusChip extends StatelessWidget {
  const AlertStatusChip({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.red;
        break;

      case 'resolved':
        color = Colors.green;
        break;

      default:
        color = Colors.orange;
    }

    return Chip(
      avatar: Icon(
        Icons.circle,
        size: 12,
        color: color,
      ),
      label: Text(
        status.toUpperCase(),
      ),
    );
  }
}