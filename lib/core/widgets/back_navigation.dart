import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void popOrGo(BuildContext context, String fallbackLocation) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(fallbackLocation);
  }
}

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    required this.fallbackLocation,
    this.onPressed,
    this.icon = Icons.arrow_back_ios_new,
    this.color = Colors.white,
    this.tooltip = 'Back',
  });

  final String fallbackLocation;
  final VoidCallback? onPressed;
  final IconData icon;
  final Color color;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: IconButton(
        onPressed: onPressed ?? () => popOrGo(context, fallbackLocation),
        tooltip: tooltip,
        color: color,
        icon: Icon(icon),
      ),
    );
  }
}

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    required this.fallbackLocation,
    this.onBack,
  });

  final String title;
  final String fallbackLocation;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppBackButton(fallbackLocation: fallbackLocation, onPressed: onBack),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontSize: 36),
          ),
        ),
      ],
    );
  }
}
