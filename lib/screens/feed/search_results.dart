import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/common/article_card.dart';
import 'package:news_app/common/article_loading_shimmer.dart';
import 'package:news_app/constants/constants.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/screens/feed/widgets/show_dialog_box.dart';

class SearchResults extends ConsumerStatefulWidget {
  const SearchResults({
    super.key,
    required this.query,
  });
  final String query;

  @override
  ConsumerState<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends ConsumerState<SearchResults> {
  bool showFab = false;
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pageKey = ValueKey('search-results');
    const duration = Duration(milliseconds: 300);
    final size = MediaQuery.of(context).size;
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
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          // hide fab when scrolling down and show when scrolling up
          final ScrollDirection direction = notification.direction;
          setState(() {
            if (direction == ScrollDirection.reverse) {
              showFab = false;
            } else if (direction == ScrollDirection.forward) {
              showFab = true;
            }
          });

          // if at start of list, hide fab
          final pixels = notification.metrics.pixels;
          const threshold = 200;
          setState(() {
            if (pixels < threshold) {
              showFab = false;
            }
          });

          return true;
        },
        child: ListView.custom(
          key: pageKey,
          controller: scrollController,
          // semanticChildCount: 99,
          childrenDelegate: SliverChildBuilderDelegate(
            (context, index) {
              // when index exceeds pageSize, page will increase by 1
              final page = index ~/ pageSize + 1;
              final indexInPage = index % pageSize;

              final articles = ref.watch(
                  searchResultsProvider(query: widget.query, page: page));

              return articles.when(
                data: (articles) {
                  if (articles.isEmpty) {
                    if (index > 0) {
                      return null;
                    }

                    return Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * 0.4),
                        child: const Column(
                          children: [
                            Icon(Icons.error),
                            SizedBox(height: 8.0),
                            Text(
                              'No results found',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (indexInPage >= articles.length) {
                    return null;
                  }

                  final article = articles[indexInPage];
                  return Column(
                    children: [
                      ArticleCard(article: article),
                      const Divider(indent: 12.0, endIndent: 12.0),
                    ],
                  );
                },
                error: (error, stackTrace) {
                  if (index > 0) {
                    return null;
                  }

                  return Center(
                    child: Text(error.toString()),
                  );
                },
                loading: () {
                  return const ArticleLoadingShimmer();
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: AnimatedSlide(
        duration: duration,
        offset: showFab ? const Offset(0, 0) : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: duration,
          opacity: showFab ? 1 : 0,
          child: FloatingActionButton(
            child: const Icon(Icons.arrow_upward),
            onPressed: () {
              if (scrollController.hasClients) {
                final position = scrollController.position.minScrollExtent;
                scrollController.animateTo(
                  position,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
                setState(() {
                  showFab = false;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
