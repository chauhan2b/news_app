import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/providers/dark_theme_state.dart';

import 'package:news_app/routing/router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final darkMode = ref.watch(darkThemeStateProvider);
    final systemTheme = ref.watch(systemThemeStateProvider);
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          splashColor: lightColorScheme?.primary.withOpacity(0.05),
          highlightColor: lightColorScheme?.primary.withOpacity(0.1),
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: darkColorScheme,
          splashColor: darkColorScheme?.primary.withOpacity(0.1),
          highlightColor: darkColorScheme?.primary.withOpacity(0.1),
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        themeMode: systemTheme.value == true
            ? ThemeMode.system
            : darkMode.value == true
                ? ThemeMode.dark
                : ThemeMode.light,
        routerConfig: goRouter,
      ),
    );
  }
}
