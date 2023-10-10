import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/providers/dark_theme_state.dart';
import 'package:news_app/screens/settings/widgets/category_dropdown.dart';
import 'package:news_app/screens/settings/widgets/country_dropdown.dart';

import '../../routing/router.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkTheme = ref.watch(darkThemeStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            leading: darkTheme
                ? const Icon(Icons.dark_mode)
                : const Icon(Icons.dark_mode_outlined),
            title: const Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            trailing: Switch(
              value: darkTheme,
              onChanged: (value) {
                ref.read(darkThemeStateProvider.notifier).toggleDarkMode();
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
          const CountryDropdown(),
          const CategoryDropdown(),
        ],
      ),
    );
  }
}
