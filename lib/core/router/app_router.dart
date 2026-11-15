import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/admin_navigation_shell.dart';
import '../../features/admin/bookings/admin_bookings_screen.dart';
import '../../features/admin/customers/admin_customers_screen.dart';
import '../../features/admin/dashboard/admin_dashboard_screen.dart';
import '../../features/admin/reviews/admin_reviews_screen.dart';
import '../../features/admin/settings/admin_settings_screen.dart';
import '../../features/auth/admin_login_screen.dart';
import '../../features/auth/admin_signup_screen.dart';
import '../../features/auth/customer_login_screen.dart';
import '../../features/auth/customer_signup_screen.dart';
import '../../features/auth/role_selection_screen.dart';
import '../../features/customer/booking/booking_calendar_flow_screen.dart';
import '../../features/customer/explore/customer_explore_screen.dart';
import '../../features/customer/home/customer_home_screen.dart';
import '../../features/customer/profile/customer_profile_screen.dart';

final GoRouter appRouter = createAppRouter();

GoRouter createAppRouter({String initialLocation = '/auth/role-selection'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/auth/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/auth/admin/login',
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: '/auth/admin/signup',
        builder: (context, state) => const AdminSignupScreen(),
      ),
      GoRoute(
        path: '/auth/customer/login',
        builder: (context, state) => const CustomerLoginScreen(),
      ),
      GoRoute(
        path: '/auth/customer/signup',
        builder: (context, state) => const CustomerSignupScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AdminNavigationShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/admin/dashboard',
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/admin/bookings',
            builder: (context, state) => const AdminBookingsScreen(),
          ),
          GoRoute(
            path: '/admin/customers',
            builder: (context, state) => const AdminCustomersScreen(),
          ),
          GoRoute(
            path: '/admin/reviews',
            builder: (context, state) => AdminReviewsScreen(
              onBack: () => context.go('/admin/dashboard'),
            ),
          ),
          GoRoute(
            path: '/admin/settings',
            builder: (context, state) => const AdminSettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/customer/home',
        builder: (context, state) => const CustomerHomeScreen(),
      ),
      GoRoute(
        path: '/customer/explore',
        builder: (context, state) => const CustomerExploreScreen(),
      ),
      GoRoute(
        path: '/customer/booking/calendar',
        builder: (context, state) => const BookingCalendarFlowScreen(),
      ),
      GoRoute(
        path: '/customer/profile',
        builder: (context, state) => const CustomerProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Text(
          'Page not found: ${state.uri.path}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
