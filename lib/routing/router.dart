import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/screens/auth/password_reset_screen.dart';
import 'package:news_app/screens/settings/manage_sources.dart';
import 'package:news_app/screens/feed/my_feed.dart';
import 'package:news_app/screens/feed/search_results.dart';
import 'package:news_app/screens/settings/settings.dart';
import 'package:news_app/screens/headlines/top_headlines.dart';

import '../repositories/auth_repository.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home_screen.dart';

enum AppRoute {
  homeScreen,
  myFeed,
  topHeadlines,
  settings,
  searchResults,
  manageSources,
  loginScreen,
  passwordReset,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home-screen',
    routes: [
      GoRoute(
          name: AppRoute.loginScreen.name,
          path: '/login',
          builder: (context, state) => LoginScreen(),
          routes: [
            GoRoute(
              name: AppRoute.passwordReset.name,
              path: 'password-reset',
              builder: (context, state) => PasswordResetScreen(),
            ),
          ]),
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
    redirect: (context, state) {
      final authState = ref.watch(authStateChangesProvider);

      // this allows user to go to password reset screen if user is not logged in
      if (state.uri.path == '/login/password-reset') {
        return '/login/password-reset';
      }

      if (authState.value == null) {
        return '/login';
      } else if (authState.value != null && state.uri.path == '/login') {
        return '/home-screen';
      } else {
        return null;
      }
    },
  );
});
