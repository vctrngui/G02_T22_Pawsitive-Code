import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_placeholder_screen.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPlaceholderScreen(
      title: 'Admin login',
      actionLabel: 'Sign in',
      secondaryActionLabel: 'Create admin account',
      onSecondaryAction: () => context.go('/auth/admin/signup'),
    );
  }
}
