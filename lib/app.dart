import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/studio_tokens.dart';

class BlackboxStudioApp extends StatelessWidget {
  const BlackboxStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Blackbox Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: StudioTokens.background,
        colorScheme: const ColorScheme.dark(
          primary: StudioTokens.accent,
          secondary: StudioTokens.accent,
          surface: StudioTokens.background,
        ),
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            fontFamily: 'serif',
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: StudioTokens.textOnDark,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'serif',
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: StudioTokens.textOnDark,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: StudioTokens.cardText,
          ),
          bodyLarge: TextStyle(color: StudioTokens.cardText),
          bodyMedium: TextStyle(color: StudioTokens.cardMuted),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: StudioTokens.card,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? StudioTokens.cardText
                  : StudioTokens.cardMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
