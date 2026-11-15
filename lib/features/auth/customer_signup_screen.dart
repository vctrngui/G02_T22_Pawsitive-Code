import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_placeholder_screen.dart';

class CustomerSignupScreen extends StatelessWidget {
  const CustomerSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPlaceholderScreen(
      title: 'Customer sign up',
      actionLabel: 'Create account',
      secondaryActionLabel: 'Already have an account? Sign in',
      onSecondaryAction: () => context.go('/auth/customer/login'),
      isSignup: true,
    );
  }
}
