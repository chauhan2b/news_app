import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/constants/app_theme.dart';
import 'package:news_app/providers/device_theme_state.dart';

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
    final materialYou = ref.watch(materialYouStateProvider);
    final appTheme = ref.watch(appThemeProvider);

    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: materialYou.value == true
            ? appTheme.lightTheme(lightColorScheme)
            : appTheme.defaultLightTheme(),
        darkTheme: materialYou.value == true
            ? appTheme.darkTheme(darkColorScheme)
            : appTheme.defaultDarkTheme(),
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
