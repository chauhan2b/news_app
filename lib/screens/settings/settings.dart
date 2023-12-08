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
    final darkTheme = ref.watch(darkThemeStateProvider);
    final systemTheme = ref.watch(systemThemeStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 540, // centered container with max with for desktop
          ),
          child: ListView(
            // physics: const NeverScrollableScrollPhysics(),
            children: [
              const SettingsHeader(text: 'Profile'),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('My Profile'),
                onTap: () {
                  context.pushNamed(AppRoute.myProfile.name);
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmarks_outlined),
                title: const Text('My Bookmarks'),
                onTap: () {
                  // add route
                },
              ),
              const SettingsHeader(text: 'Theme'),
              ListTile(
                leading: const Icon(Icons.phone_android),
                title: const Text(
                  'Follow System',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                trailing: Switch(
                  value: systemTheme.value ?? false,
                  onChanged: (value) {
                    ref
                        .read(systemThemeStateProvider.notifier)
                        .toggleSystemTheme();
                  },
                ),
              ),
              ListTile(
                leading: darkTheme.value == true
                    ? const Icon(Icons.dark_mode)
                    : const Icon(
                        Icons.dark_mode_outlined,
                      ),
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                trailing: Switch(
                  value: darkTheme.value ?? false,
                  onChanged: systemTheme.value == true
                      ? null
                      : (value) {
                          ref
                              .read(darkThemeStateProvider.notifier)
                              .toggleDarkMode();
                        },
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
        ),
      ),
    );
  }
}
