import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/widgets/show_dialog_box.dart';

import '../widgets/articles_builder.dart';

class SearchResults extends ConsumerWidget {
  const SearchResults({
    super.key,
    required this.query,
  });
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchResultsProvider(query));
    final scrollController = ScrollController();
    const pageKey = ValueKey('search-results');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your results'),
        actions: [
          IconButton(
            onPressed: () async {
              await showDialogBox(context, ref);
            },
            icon: const Icon(Icons.sort),
          )
        ],
      ),
      body: results.when(
        data: (news) => ArticlesBuilder(
          articles: news,
          controller: scrollController,
          pageKey: pageKey,
        ),
        error: (error, stackTrace) => Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            error.toString(),
            textAlign: TextAlign.center,
          ),
        )),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
