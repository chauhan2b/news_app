import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/providers/dark_theme_provider.dart';

import '../routing/router.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkModeAsync = ref.watch(darkThemeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          darkModeAsync.when(
            data: (darkMode) => ListTile(
              leading: darkMode
                  ? const Icon(Icons.dark_mode)
                  : const Icon(Icons.dark_mode_outlined),
              title: const Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              trailing: Switch(
                value: darkMode,
                onChanged: (value) {
                  ref.read(darkThemeProvider.notifier).setDarkMode(value);
                },
              ),
            ),
            error: (error, stackTrace) =>
                const Text('Error fetching dark theme status'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          // ListTile(
          //   leading: _isDarkModeEnabled
          //       ? const Icon(Icons.dark_mode)
          //       : const Icon(Icons.dark_mode_outlined),
          //   title: const Text(
          //     'Dark Mode',
          //     style: TextStyle(
          //       fontSize: 16.0,
          //     ),
          //   ),
          //   trailing: Switch(
          //     value: _isDarkModeEnabled,
          //     onChanged: null,
          //   ),
          // ),
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
