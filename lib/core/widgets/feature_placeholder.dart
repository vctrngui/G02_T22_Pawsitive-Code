import 'package:flutter/material.dart';

import '../theme/studio_tokens.dart';

class FeaturePlaceholder extends StatelessWidget {
  const FeaturePlaceholder({
    super.key,
    required this.title,
    this.description = 'This screen is ready for the team to implement.',
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StudioTokens.background,
      appBar: AppBar(
        backgroundColor: StudioTokens.background,
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: StudioTokens.mutedOnDark),
          ),
        ),
      ),
    );
  }
}
