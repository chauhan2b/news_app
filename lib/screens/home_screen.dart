import 'package:flutter/material.dart';
import 'package:news_app/screens/settings/settings.dart';
import 'package:news_app/screens/headlines/top_headlines.dart';

import 'feed/my_feed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        const MyFeed(),
        const TopHeadlines(),
        const Settings(),
      ][currentIndex],
      bottomNavigationBar: NavigationBar(
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
      ),
    );
  }
}
