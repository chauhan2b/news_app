import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'top_headlines_country.g.dart';

List<String> _countries = [
  'in',
  'jp',
  'us',
];

// final countriesProvider = Provider<List<String>>((ref) {
//   return _countries;
// });

@riverpod
List<String> countries(CountriesRef ref) {
  return _countries;
}

@riverpod
class CountriesState extends _$CountriesState {
  void _saveCountryPreference(String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('country', value);
  }

  void _loadCountryPreference() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('country') ?? _countries[0];
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

  Future<String> get() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return state;
  }
}
