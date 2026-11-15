import 'package:flutter/material.dart';

import '../../core/theme/studio_tokens.dart';

class AuthPlaceholderScreen extends StatelessWidget {
  const AuthPlaceholderScreen({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.secondaryActionLabel,
    required this.onSecondaryAction,
    this.isSignup = false,
  });

  final String title;
  final String actionLabel;
  final String secondaryActionLabel;
  final VoidCallback onSecondaryAction;
  final bool isSignup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StudioTokens.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Authentication is ready to be connected.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: StudioTokens.mutedOnDark),
                  ),
                  const SizedBox(height: 32),
                  if (isSignup) ...[
                    const TextField(
                      decoration: InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                  ],
                  const TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(onPressed: null, child: Text(actionLabel)),
                  TextButton(
                    onPressed: onSecondaryAction,
                    child: Text(secondaryActionLabel),
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
