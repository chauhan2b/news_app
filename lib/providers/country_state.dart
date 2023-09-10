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
  void _saveCountryPreference(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(userCountry, value);
  }

  void _loadCountryPreference() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(userCountry) ?? _countries[0];
  }

  @override
  String build() {
    _loadCountryPreference();
    return _countries[0];
  }

  void update(String country) {
    state = country;
    _saveCountryPreference(state);
  }
}
