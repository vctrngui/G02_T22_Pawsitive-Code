import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'studio_tokens.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: StudioTokens.accent,
          brightness: Brightness.dark,
        ).copyWith(
          primary: StudioTokens.accent,
          onPrimary: StudioTokens.background,
          secondary: StudioTokens.accent,
          surface: StudioTokens.darkSurface,
          onSurface: Colors.white,
        );
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: StudioTokens.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: StudioTokens.background,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(StudioTokens.cardRadius),
        ),
      ),
    );
    final baseTextTheme = baseTheme.textTheme;
    final headerTextTheme = GoogleFonts.frauncesTextTheme(baseTextTheme);
    final bodyTextTheme = GoogleFonts.ptSansTextTheme(baseTextTheme);
    final textTheme = baseTextTheme.copyWith(
      displayLarge: headerTextTheme.displayLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: headerTextTheme.displayMedium?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: headerTextTheme.displaySmall?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: headerTextTheme.headlineLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: headerTextTheme.headlineMedium?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: headerTextTheme.headlineSmall?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: headerTextTheme.titleLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: bodyTextTheme.bodyLarge?.copyWith(color: Colors.white),
      bodyMedium: bodyTextTheme.bodyMedium?.copyWith(color: Colors.white),
      bodySmall: bodyTextTheme.bodySmall?.copyWith(color: Colors.white),
      labelLarge: bodyTextTheme.labelLarge?.copyWith(color: Colors.white),
      labelMedium: bodyTextTheme.labelMedium?.copyWith(color: Colors.white),
      labelSmall: bodyTextTheme.labelSmall?.copyWith(color: Colors.white),
    );

    return baseTheme.copyWith(
      textTheme: textTheme,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: StudioTokens.darkSurface,
        indicatorColor: StudioTokens.accent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          return textTheme.labelMedium!.copyWith(
            color: states.contains(WidgetState.selected)
                ? StudioTokens.accent
                : Colors.white70,
            fontSize: 12,
          );
        }),
      ),
    );
  }
}
