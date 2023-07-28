import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'domains_state.g.dart';

@riverpod
class Domains extends _$Domains {
  Future<List<String>> _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('domains') ?? [];
  }

  void _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final domains = state.value ?? [];
    prefs.setStringList('domains', domains);
  }

  @override
  Future<List<String>> build() async {
    // fetch user's saved domains
    return _load();
  }

  void add(String domain) async {
    // state = [...state, domain];
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final domains = state.value ?? [];
      return [...domains, domain];
    });

    // save on device
    _save();
  }

  void remove(String domain) async {
    // state = state.where((element) => element != domain).toList();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final domains = state.value ?? [];
      return domains.where((val) => val != domain).toList();
    });

    // save on device
    _save();
  }

  Future<List<String>> get() async {
    return _load();
  }
}
