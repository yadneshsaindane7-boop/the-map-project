import 'package:flutter/material.dart';

class EmptyAlerts extends StatelessWidget {
  const EmptyAlerts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 80,
            color: Colors.grey,
          ),

          SizedBox(height: 16),

          Text(
            "No active alerts",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}