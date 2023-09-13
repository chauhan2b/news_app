import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/providers/dark_theme_state.dart';
import 'package:news_app/providers/country_state.dart';
import 'package:news_app/screens/settings/widgets/category_dropdown.dart';
import 'package:news_app/screens/settings/widgets/top_headlines_dropdown.dart';
import 'package:shimmer/shimmer.dart';

import '../../routing/router.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).colorScheme.primary;

    final darkTheme = ref.watch(darkThemeStateProvider);
    final country = ref.watch(countriesStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        // physics: const NeverScrollableScrollPhysics(),
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
          TopHeadlinesDropdown(country: country),
          const CategoryDropdown(),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Shimmer.fromColors(
              baseColor: primaryColor.withOpacity(0.05),
              highlightColor: primaryColor.withOpacity(0.2),
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.24,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 24,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 24,
                        width: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
