import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerAppShell extends StatelessWidget {
  const CustomerAppShell({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  static const _paths = [
    '/customer/home',
    '/customer/explore',
    '/customer/booking',
    '/customer/profile',
  ];

  @override
  Widget build(BuildContext context) {
    final index = _paths.indexWhere((p) => location.startsWith(p));
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index < 0 ? 0 : index,
        onDestinationSelected: (i) => context.go(_paths[i]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Booking',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
