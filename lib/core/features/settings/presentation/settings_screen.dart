import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/settings_header.dart';
import '../../../routing/router.dart';
import '../../../theme/device_theme_provider.dart';
import 'category_dropdown_button.dart';
import 'country_dropdown_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  get child => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkTheme = ref.watch(darkModeProvider).requireValue;
    final systemTheme = ref.watch(systemThemeProvider).requireValue;
    final materialYou = ref.watch(materialYouProvider).requireValue;

    return Scaffold(
      appBar: AppBar(
        centerTitle: kIsWeb ? true : false,
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
                  value: systemTheme,
                  onChanged: (value) {
                    ref.read(systemThemeProvider.notifier).toggleSystemTheme();
                  },
                ),
              ),
              ListTile(
                leading: darkTheme
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
                  value: darkTheme,
                  onChanged: systemTheme
                      ? null
                      : (value) {
                          ref.read(darkModeProvider.notifier).toggleDarkMode();
                        },
                ),
              ),
              if (!kIsWeb && Platform.isAndroid)
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
                    value: materialYou,
                    onChanged: (value) {
                      ref
                          .read(materialYouProvider.notifier)
                          .toggleMaterialYou();
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
            ],
          ),
        ),
      ),
    );
  }
}
