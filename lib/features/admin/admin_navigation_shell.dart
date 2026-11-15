import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/studio_tokens.dart';

class AdminNavigationShell extends StatelessWidget {
  const AdminNavigationShell({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  static const _destinations = <_AdminDestination>[
    _AdminDestination(
      'Dashboard',
      Icons.dashboard_outlined,
      '/admin/dashboard',
    ),
    _AdminDestination(
      'Bookings',
      Icons.calendar_month_outlined,
      '/admin/bookings',
    ),
    _AdminDestination('Customers', Icons.people_outline, '/admin/customers'),
    _AdminDestination('Reviews', Icons.star_outline, '/admin/reviews'),
    _AdminDestination('Settings', Icons.tune, '/admin/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _destinations.indexWhere(
      (destination) => destination.location == location,
    );
    final safeSelectedIndex = selectedIndex < 0 ? 0 : selectedIndex;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide =
            constraints.maxWidth >= 800 && constraints.maxHeight >= 600;
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                if (isWide) ...[
                  NavigationRail(
                    selectedIndex: safeSelectedIndex,
                    onDestinationSelected: (index) {
                      context.go(_destinations[index].location);
                    },
                    backgroundColor: StudioTokens.background,
                    indicatorColor: const Color(0x33FFD600),
                    labelType: NavigationRailLabelType.all,
                    leading: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 28),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: StudioTokens.accent,
                        size: 30,
                      ),
                    ),
                    destinations: [
                      for (final destination in _destinations)
                        NavigationRailDestination(
                          icon: Icon(destination.icon),
                          label: Text(destination.label),
                        ),
                    ],
                  ),
                  const VerticalDivider(width: 1, color: Color(0xFF303030)),
                ],
                Expanded(child: child),
              ],
            ),
          ),
          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: safeSelectedIndex,
                  onDestinationSelected: (index) {
                    context.go(_destinations[index].location);
                  },
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  destinations: [
                    for (final destination in _destinations)
                      NavigationDestination(
                        icon: Icon(
                          destination.icon,
                          color: const Color(0xFFBDBDBD),
                        ),
                        selectedIcon: Icon(
                          destination.icon,
                          color: StudioTokens.cardText,
                        ),
                        label: destination.label,
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class _AdminDestination {
  const _AdminDestination(this.label, this.icon, this.location);

  final String label;
  final IconData icon;
  final String location;
}
