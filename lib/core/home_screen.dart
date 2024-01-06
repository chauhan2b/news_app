import 'package:flutter/material.dart';
import 'package:news_app/core/features/settings/presentation/settings_screen.dart';
import 'package:news_app/core/features/headlines/presentation/top_headlines_screen.dart';

import 'features/feed/presentation/my_feed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> _mainScreens = [
    const MyFeed(),
    const TopHeadlinesScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (MediaQuery.of(context).size.width >= 600)
            NavigationRail(
                onDestinationSelected: (value) => setState(
                      () {
                        currentIndex = value;
                      },
                    ),
                labelType: NavigationRailLabelType.all,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.07),
                leading: Column(
                  children: [
                    Icon(
                      Icons.feed,
                      size: 52,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.8),
                    ),
                    const Text(
                      'News',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 18.0),
                  ],
                ),
                useIndicator: true,
                minWidth: 100,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.feed_outlined),
                    selectedIcon: Icon(Icons.feed),
                    label: Text('My Feed'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.public),
                    selectedIcon: Icon(Icons.public_outlined),
                    label: Text('Headlines'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                ],
                selectedIndex: currentIndex),
          // always visible
          Expanded(child: _mainScreens[currentIndex]),
        ],
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width < 600
          ? NavigationBar(
              onDestinationSelected: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              selectedIndex: currentIndex,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.feed_outlined),
                  selectedIcon: Icon(Icons.feed),
                  label: 'My Feed',
                  tooltip: '',
                ),
                NavigationDestination(
                  icon: Icon(Icons.public),
                  selectedIcon: Icon(Icons.public_outlined),
                  label: 'Headlines',
                  tooltip: '',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: 'Settings',
                  tooltip: '',
                ),
              ],
            )
          : null,
    );
  }
}
