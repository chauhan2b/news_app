import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_theme.g.dart';

class AppTheme {
  ThemeData lightTheme(ColorScheme? lightColorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      splashColor: lightColorScheme?.primary.withOpacity(0.05),
      highlightColor: lightColorScheme?.primary.withOpacity(0.1),
      fontFamily: GoogleFonts.poppins().fontFamily,
    );
  }

  ThemeData darkTheme(ColorScheme? darkColorScheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      splashColor: darkColorScheme?.primary.withOpacity(0.1),
      highlightColor: darkColorScheme?.primary.withOpacity(0.1),
      fontFamily: GoogleFonts.poppins().fontFamily,
    );
  }

  ThemeData defaultLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.poppins().fontFamily,
    );
  }

  ThemeData defaultDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.poppins().fontFamily,
    );
  }
}

@riverpod
AppTheme appTheme(AppThemeRef ref) {
  return AppTheme();
}
