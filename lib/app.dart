import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:news_app/routing/router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
    required this.savedThemeMode,
  });
  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (light, dark) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: light,
        darkTheme: dark,
        routerConfig: goRouter,
      ),
    );
  }
}
