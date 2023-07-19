import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkModeService {
  Future<bool> loadDarkModeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkModeEnabled') ?? false;
  }

  Future<void> saveDarkModeState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkModeEnabled', value);
  }
}

final darkModeServiceProvider = Provider<DarkModeService>((ref) {
  return DarkModeService();
});
