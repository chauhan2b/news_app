import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/core/common/settings_header.dart';
import 'package:news_app/core/theme/device_theme_provider.dart';
import 'package:news_app/core/features/settings/presentation/category_dropdown_button.dart';
import 'package:news_app/core/features/settings/presentation/country_dropdown_button.dart';

import '../../../routing/router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkTheme = ref.watch(darkModeProvider);
    final systemTheme = ref.watch(systemThemeProvider);
    final materialYou = ref.watch(materialYouProvider);

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
                  context.pushNamed(AppRoute.bookmarkScreen.name);
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
                    ref.read(systemThemeProvider.notifier).toggleSystemTheme();
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
                          ref.read(darkModeProvider.notifier).toggleDarkMode();
                        },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.water),
                title: const Text(
                  'Material You',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                subtitle: const Text('Use colors from wallpaper'),
                trailing: Switch(
                  value: materialYou.value ?? true,
                  onChanged: (value) {
                    ref.read(materialYouProvider.notifier).toggleMaterialYou();
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
              const CountryDropdownButton(),
              const CategoryDropdownButton(),
              const SizedBox(height: 8),
              const Text(
                'Alpha build v3.0.0.\nExpect unimplemented features and bugs.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
