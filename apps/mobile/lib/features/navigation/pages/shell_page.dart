import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../alerts/pages/alerts_page.dart';
import '../../map/pages/map_page.dart';
import '../../profile/pages/profile_page.dart';
import '../../report/pages/report_page.dart';

import '../providers/navigation_provider.dart';
import '../widgets/bottom_nav.dart';

class ShellPage extends ConsumerWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(
      navigationProvider,
    );

    final pages = [
      const MapPage(),
      const ReportPage(),
      const AlertsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar:
          const BottomNav(),
    );
  }
}