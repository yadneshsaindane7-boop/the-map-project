import 'package:flutter/material.dart';

class ProfileAchievements extends StatelessWidget {
  const ProfileAchievements({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Achievements",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _AchievementChip(
                  icon: Icons.emoji_events,
                  color: Colors.amber,
                  label: "First Report",
                ),

                _AchievementChip(
                  icon: Icons.shield,
                  color: Colors.green,
                  label: "Road Guardian",
                ),

                _AchievementChip(
                  icon: Icons.groups,
                  color: Colors.blue,
                  label: "Community Helper",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementChip extends StatelessWidget {
  const _AchievementChip({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(
          icon,
          color: color,
          size: 18,
        ),
      ),
      label: Text(label),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
    );
  }
}