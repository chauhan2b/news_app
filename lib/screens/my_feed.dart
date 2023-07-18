import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/repositories/news_repository.dart';

import '../widgets/articles_builder.dart';

class MyFeed extends ConsumerWidget {
  const MyFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureNews = ref.watch(newsListFutureProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Feed'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          return await ref.refresh(newsListFutureProvider);
        },
        child: futureNews.when(
          data: (news) => ArticlesBuilder(articles: news),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
