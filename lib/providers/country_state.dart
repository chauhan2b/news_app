import 'package:news_app/constants/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'country_state.g.dart';

List<String> _countries = [
  'in',
  'jp',
  'us',
];

@riverpod
List<String> countries(CountriesRef ref) {
  return _countries;
}

@Riverpod(keepAlive: true)
class CountriesState extends _$CountriesState {
  Future<String> _loadCountryPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userCountry) ?? _countries[0];
  }

  void _saveCountryPreference(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userCountry, value);
  }

  @override
  Future<String> build() async {
    return _loadCountryPreference();
  }

  void updateCountry(String country) async {
    state = const AsyncValue.loading();
    _saveCountryPreference(country);
    state = await AsyncValue.guard(() => _loadCountryPreference());
  }
}
