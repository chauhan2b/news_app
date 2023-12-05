import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

part 'dark_theme_state.g.dart';

@riverpod
class DarkThemeState extends _$DarkThemeState {
  Future<bool> _loadDarkThemeState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(darkModePreference) ?? false;
  }

  void _saveDarkThemeState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(darkModePreference, value);
  }

  @override
  Future<bool> build() async {
    return _loadDarkThemeState();
  }

  void toggleDarkMode() async {
    state = const AsyncValue.loading();
    bool value = await _loadDarkThemeState();
    _saveDarkThemeState(!value);
    state = await AsyncValue.guard(() => _loadDarkThemeState());
  }
}

@riverpod
class SystemThemeState extends _$SystemThemeState {
  Future<bool> _loadSystemThemeState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(systemTheme) ?? true;
  }

  void _saveSystemThemeState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(systemTheme, value);
  }

  @override
  Future<bool> build() async {
    return _loadSystemThemeState();
  }

  void toggleSystemTheme() async {
    state = const AsyncValue.loading();
    bool value = await _loadSystemThemeState();
    _saveSystemThemeState(!value);
    state = await AsyncValue.guard(() => _loadSystemThemeState());
  }
}
