import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/screens/my_feed.dart';
import 'package:news_app/screens/settings.dart';
import 'package:news_app/screens/top_headlines.dart';

import '../screens/home_screen.dart';

enum AppRoute {
  homeScreen,
  myFeed,
  topHeadlines,
  settings,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home-screen',
    routes: [
      GoRoute(
        name: AppRoute.homeScreen.name,
        path: '/home-screen',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            name: AppRoute.myFeed.name,
            path: 'my-feed',
            builder: (context, state) => const MyFeed(),
          ),
          GoRoute(
            name: AppRoute.topHeadlines.name,
            path: 'top-headlines',
            builder: (context, state) => const TopHeadlines(),
          ),
          GoRoute(
            name: AppRoute.settings.name,
            path: 'settings',
            builder: (context, state) => const Settings(),
          ),
        ],
      ),
    ],
  );
});
