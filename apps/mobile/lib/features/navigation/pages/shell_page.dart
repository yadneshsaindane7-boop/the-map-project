import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../map/pages/map_page.dart';
import '../../report/pages/report_page.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_nav.dart';

class ShellPage extends ConsumerWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationProvider);

    final pages = [
      const MapPage(),
      const ReportPage(),

      const Scaffold(
        body: Center(
          child: Text(
            'Alerts',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),

      const Scaffold(
        body: Center(
          child: Text(
            'Profile',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}