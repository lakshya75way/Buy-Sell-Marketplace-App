import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/navigation_providers.dart';
import 'features/auth/presentation/screens/profile_screen.dart';
import 'features/listings/presentation/screens/dashboard_screen.dart';
import 'features/listings/presentation/screens/history_screen.dart';
import 'home_screen.dart';

class MainConfigScreen extends ConsumerStatefulWidget {
  const MainConfigScreen({super.key});

  @override
  ConsumerState<MainConfigScreen> createState() => _MainConfigScreenState();
}

class _MainConfigScreenState extends ConsumerState<MainConfigScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const DashboardScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationNotifierProvider);

    return Scaffold(
      body: _screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(navigationNotifierProvider.notifier).setIndex(index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
