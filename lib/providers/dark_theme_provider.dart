import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

part 'dark_theme_provider.g.dart';

@riverpod
class DarkTheme extends _$DarkTheme {
  Future<bool> _fetchDarkModePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(darkModePreference) ?? false;
  }

  void _saveDarkModePreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(darkModePreference, value);
  }

  @override
  Future<bool> build() async {
    // load user saved theme
    return _fetchDarkModePreference();
  }

  Future<void> getDarkMode() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _fetchDarkModePreference();
    });
  }

  Future<void> setDarkMode(bool value) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      _saveDarkModePreference(value);
      return _fetchDarkModePreference();
    });
  }
}
