import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/email_verification_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/password_reset_screen.dart';
import '../features/bookmarks/presentation/bookmark_screen.dart';
import '../features/feed/presentation/manage_sources_screen.dart';
import '../features/feed/presentation/my_feed.dart';
import '../features/headlines/presentation/top_headlines_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/search/presentation/search_results_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../home_screen.dart';

enum AppRoute {
  homeScreen,
  myFeed,
  topHeadlines,
  settings,
  searchResults,
  manageSources,
  loginScreen,
  passwordReset,
  myProfile,
  bookmarkScreen,
  emailVerificationScreen,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final isLoggedIn = authState.value != null;

  return GoRouter(
    initialLocation: isLoggedIn ? '/home-screen' : '/login',
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
            GoRoute(
              name: AppRoute.emailVerificationScreen.name,
              path: 'email-verification',
              builder: (context, state) => const EmailVerificationScreen(),
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
              return SearchResultsScreen(query: query);
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRoute.topHeadlines.name,
        path: '/top-headlines',
        builder: (context, state) => const TopHeadlinesScreen(),
      ),
      GoRoute(
        name: AppRoute.settings.name,
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            name: AppRoute.myProfile.name,
            path: 'my-profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            name: AppRoute.manageSources.name,
            path: 'manage-sources',
            builder: (context, state) => const ManageSourcesScreen(),
          ),
          GoRoute(
            name: AppRoute.bookmarkScreen.name,
            path: 'bookmark-screen',
            builder: (context, state) => const BookmarkScreen(),
          ),
        ],
      ),
    ],
    redirect: (context, state) async {
      if (kDebugMode) {
        print('redirect called');

        print(state.uri.path);
      }

      final authState = ref.read(authStateChangesProvider);
      final isLoggedIn = authState.value != null;

      // this allows user to go to password reset screen if user is not logged in
      if (state.uri.path == '/login/password-reset') {
        return '/login/password-reset';
      }

      if (!isLoggedIn) {
        return '/login';
      } else {
        final user = authState.value!;
        await user.reload();

        if (!user.emailVerified) {
          return '/login/email-verification';
        } else {
          if (state.uri.path == '/login') {
            return '/home-screen';
          } else {
            return null;
          }
        }
      }
    },
  );
});
