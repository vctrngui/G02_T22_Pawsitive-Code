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
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: StudioTokens.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: StudioTokens.accent,
          brightness: Brightness.dark,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
