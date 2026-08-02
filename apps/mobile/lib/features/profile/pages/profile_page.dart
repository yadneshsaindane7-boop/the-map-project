import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_provider.dart';

import '../widgets/logout_button.dart';
import '../widgets/profile_achievements.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_stats_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: profile.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        data: (user) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ProfileHeader(
                  profile: user,
                ),

                const SizedBox(height: 20),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.25,
                  children: [
                    ProfileStatsCard(
                      title: "Reports",
                      value:
                          user.totalReports.toString(),
                      icon: Icons.description,
                      iconColor: Colors.blue,
                    ),
                    ProfileStatsCard(
                      title: "Active",
                      value:
                          user.activeReports.toString(),
                      icon: Icons.warning,
                      iconColor: Colors.orange,
                    ),
                    const ProfileStatsCard(
                      title: "Reputation",
                      value: "95%",
                      icon: Icons.star,
                      iconColor: Colors.amber,
                    ),
                    const ProfileStatsCard(
                      title: "Achievements",
                      value: "3",
                      icon: Icons.emoji_events,
                      iconColor: Colors.green,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const ProfileAchievements(),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Settings",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight:
                              FontWeight.bold,
                        ),
                  ),
                ),

                const SizedBox(height: 10),

                ProfileMenuTile(
                  icon: Icons.notifications,
                  title: "Notifications",
                  subtitle:
                      "Manage notification preferences",
                  onTap: () {},
                ),

                ProfileMenuTile(
                  icon: Icons.language,
                  title: "Language",
                  subtitle: "English",
                  onTap: () {},
                ),

                ProfileMenuTile(
                  icon: Icons.info_outline,
                  title: "About",
                  subtitle:
                      "The Map Project v1.0",
                  onTap: () {},
                ),

                const SizedBox(height: 30),

                const LogoutButton(),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}