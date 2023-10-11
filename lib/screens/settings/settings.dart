import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/common/settings_header.dart';
import 'package:news_app/providers/dark_theme_state.dart';
import 'package:news_app/screens/settings/widgets/category_dropdown.dart';
import 'package:news_app/screens/settings/widgets/country_dropdown.dart';

import '../../routing/router.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkThemeFuture = ref.watch(darkThemeStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SettingsHeader(text: 'Theme'),
          ListTile(
            leading: darkThemeFuture.when(
              data: (darkMode) => darkMode
                  ? const Icon(Icons.dark_mode)
                  : const Icon(
                      Icons.dark_mode_outlined,
                    ),
              error: (error, stackTrace) =>
                  const Icon(Icons.dark_mode_outlined),
              loading: () => const Icon(Icons.dark_mode_outlined),
            ),
            title: const Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            trailing: darkThemeFuture.when(
              data: (darkTheme) => Switch(
                value: darkTheme,
                onChanged: (value) {
                  ref.read(darkThemeStateProvider.notifier).toggleDarkMode();
                },
              ),
              error: (error, stackTrace) =>
                  Switch(value: false, onChanged: (_) {}),
              loading: () => const CircularProgressIndicator(),
            ),
          ),
          const SettingsHeader(text: 'My Feed'),
          ListTile(
            leading: const Icon(Icons.newspaper_outlined),
            title: const Text('Manage sources'),
            onTap: () {
              context.pushNamed(AppRoute.manageSources.name);
            },
          ),
          const SettingsHeader(text: 'Top Headlines'),
          const CountryDropdown(),
          const CategoryDropdown(),
        ],
      ),
    );
  }
}
