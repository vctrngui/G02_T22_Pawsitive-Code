import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_placeholder_screen.dart';

class AdminSignupScreen extends StatelessWidget {
  const AdminSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPlaceholderScreen(
      title: 'Admin sign up',
      actionLabel: 'Create account',
      secondaryActionLabel: 'Already have an account? Sign in',
      onSecondaryAction: () => context.go('/auth/admin/login'),
      isSignup: true,
    );
  }
}
