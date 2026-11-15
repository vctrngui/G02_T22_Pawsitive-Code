import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photography_booking/app.dart';
import 'package:photography_booking/core/router/app_router.dart';
import 'package:photography_booking/features/admin/reviews/admin_reviews_screen.dart';
import 'package:photography_booking/features/auth/role_selection_screen.dart';

void main() {
  testWidgets('role selection links to the role-specific auth flows', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BlackboxStudioApp());

    expect(find.byType(RoleSelectionScreen), findsOneWidget);
    await tester.tap(find.text('Admin login'));
    await tester.pumpAndSettle();
    expect(find.text('Admin login'), findsOneWidget);

    await tester.tap(find.text('Create admin account'));
    await tester.pumpAndSettle();
    expect(find.text('Admin sign up'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
  });

  testWidgets('admin reviews route preserves summary, filters, and controls', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = createAppRouter(initialLocation: '/admin/reviews');
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.byType(AdminReviewsScreen), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('653 reviews'), findsOneWidget);
    expect(
      find.text('Your reply: Thank you, Siti for your review.'),
      findsOneWidget,
    );
    expect(find.byType(Switch), findsNWidgets(4));

    await tester.tap(find.text('Maternity').last);
    await tester.pumpAndSettle();
    expect(find.text('Fong'), findsOneWidget);
    expect(find.text('Siti'), findsNothing);
  });

  testWidgets('admin routes use an adaptive navigation shell', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = createAppRouter(initialLocation: '/admin/dashboard');
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    tester.view.physicalSize = const Size(1200, 480);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);

    tester.view.physicalSize = const Size(1200, 900);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('Admin Dashboard'), findsOneWidget);
    await tester.tap(find.text('Reviews'));
    await tester.pumpAndSettle();
    expect(find.byType(AdminReviewsScreen), findsOneWidget);
  });

  testWidgets('customer routes resolve to modular placeholders', (
    WidgetTester tester,
  ) async {
    final router = createAppRouter(
      initialLocation: '/customer/booking/calendar',
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Booking Calendar'), findsOneWidget);
    expect(
      find.text('This screen is ready for the team to implement.'),
      findsOneWidget,
    );
  });
}
