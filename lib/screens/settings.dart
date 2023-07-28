import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/services/dark_mode_service.dart';

import '../routing/router.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  bool _isDarkModeEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getDarkModeValue();
  }

  getDarkModeValue() async {
    _isLoading = true;
    _isDarkModeEnabled =
        await ref.read(darkModeServiceProvider).loadDarkModeState();
    setState(() {});
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ListTile(
                  leading: _isDarkModeEnabled
                      ? const Icon(Icons.dark_mode)
                      : const Icon(Icons.dark_mode_outlined),
                  title: const Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  trailing: Switch(
                    value: _isDarkModeEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isDarkModeEnabled = value;
                        _isDarkModeEnabled
                            ? AdaptiveTheme.of(context).setDark()
                            : AdaptiveTheme.of(context).setLight();
                      });
                      ref
                          .read(darkModeServiceProvider)
                          .saveDarkModeState(value);
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.newspaper_outlined),
                  title: const Text('Manage sources'),
                  onTap: () {
                    context.pushNamed(AppRoute.manageSources.name);
                  },
                ),
              ],
            ),
    );
  }
}
