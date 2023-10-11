import 'package:news_app/constants/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'domains_state.g.dart';

@Riverpod(keepAlive: true)
class Domains extends _$Domains {
  Future<List<String>> _loadDomains() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(userDomains) ?? [];
  }

  void _saveDomains(List<String> domains) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(userDomains, domains);
  }

  @override
  Future<List<String>> build() async {
    // fetch user's saved domains
    // we have to use async because we need to wait for _loadDomains
    return _loadDomains();
  }

  void add(String domain) async {
    state = const AsyncValue.loading();
    List<String> domains = await _loadDomains();
    domains = [...domains, domain];
    _saveDomains(domains);
    state = await AsyncValue.guard(() => _loadDomains());
  }

  void remove(String domain) async {
    state = const AsyncValue.loading();
    List<String> domains = await _loadDomains();
    domains = domains.where((element) => element != domain).toList();
    _saveDomains(domains);
    state = await AsyncValue.guard(() => _loadDomains());
  }
}
