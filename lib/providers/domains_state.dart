import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'domains_state.g.dart';

@Riverpod(keepAlive: true)
class Domains extends _$Domains {
  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList('domains') ?? [];
  }

  void _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('domains', state);
  }

  @override
  List<String> build() {
    // fetch user's saved domains
    _load();
    return [];
  }

  void add(String domain) async {
    state = [...state, domain];
    _save();
  }

  void remove(String domain) async {
    state = state.where((element) => element != domain).toList();
    _save();
  }
}
