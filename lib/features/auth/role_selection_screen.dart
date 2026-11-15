import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/studio_tokens.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StudioTokens.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.camera_alt_outlined,
                    size: 48,
                    color: StudioTokens.accent,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Blackbox Studio',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose how you would like to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: StudioTokens.mutedOnDark),
                  ),
                  const SizedBox(height: 32),
                  _RoleCard(
                    title: 'Admin',
                    description: 'Manage bookings, customers, and reviews.',
                    loginPath: '/auth/admin/login',
                    signupPath: '/auth/admin/signup',
                  ),
                  const SizedBox(height: 16),
                  _RoleCard(
                    title: 'Customer',
                    description: 'Explore sessions and book your photoshoot.',
                    loginPath: '/auth/customer/login',
                    signupPath: '/auth/customer/signup',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.description,
    required this.loginPath,
    required this.signupPath,
  });

  final String title;
  final String description;
  final String loginPath;
  final String signupPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: StudioTokens.card,
        borderRadius: BorderRadius.circular(StudioTokens.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => context.go(loginPath),
                  style: FilledButton.styleFrom(
                    backgroundColor: StudioTokens.accent,
                    foregroundColor: StudioTokens.cardText,
                  ),
                  child: Text('$title login'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.go(signupPath),
                  child: Text('$title sign up'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
