import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_placeholder_screen.dart';

class CustomerLoginScreen extends StatelessWidget {
  const CustomerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthPlaceholderScreen(
      title: 'Customer login',
      actionLabel: 'Sign in',
      secondaryActionLabel: 'Create customer account',
      onSecondaryAction: () => context.go('/auth/customer/signup'),
    );
  }
}
