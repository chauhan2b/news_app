import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/screens/manage_sources.dart';
import 'package:news_app/screens/my_feed.dart';
import 'package:news_app/screens/search_results.dart';
import 'package:news_app/screens/settings.dart';
import 'package:news_app/screens/top_headlines.dart';

import '../screens/home_screen.dart';

enum AppRoute {
  homeScreen,
  myFeed,
  topHeadlines,
  settings,
  searchResults,
  manageSources,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home-screen',
    routes: [
      GoRoute(
        name: AppRoute.homeScreen.name,
        path: '/home-screen',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: AppRoute.myFeed.name,
        path: '/my-feed',
        builder: (context, state) => const MyFeed(),
        routes: [
          GoRoute(
            name: AppRoute.searchResults.name,
            path: 'search-results',
            builder: (context, state) {
              final query = state.uri.queryParameters['query'] ?? '';
              return SearchResults(query: query);
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRoute.topHeadlines.name,
        path: '/top-headlines',
        builder: (context, state) => const TopHeadlines(),
      ),
      GoRoute(
        name: AppRoute.settings.name,
        path: '/settings',
        builder: (context, state) => const Settings(),
        routes: [
          GoRoute(
            name: AppRoute.manageSources.name,
            path: 'manage-sources',
            builder: (context, state) => const ManageSources(),
          ),
        ],
      ),
    ],
  );
});
