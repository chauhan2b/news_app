import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/widgets/articles_builder.dart';

class TopHeadlines extends ConsumerWidget {
  const TopHeadlines({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final futureHeadlines = ref.watch(topHeadlinesFutureProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Top Headlines'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            return await ref.refresh(topHeadlinesFutureProvider);
          },
          child: futureHeadlines.when(
            data: (headlines) => ArticlesBuilder(
              articles: headlines,
            ),
            error: (error, stackTrace) => Center(child: Text(error.toString())),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ));
  }
}
