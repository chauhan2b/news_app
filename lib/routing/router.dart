import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/screens/my_feed_screen.dart';

enum AppRoute {
  myFeed,
  topHeadlines,
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/my-feed',
    routes: [
      GoRoute(
        name: AppRoute.myFeed.name,
        path: '/my-feed',
        builder: (context, state) => const MyFeedScreen(),
      ),
    ],
  );
});
