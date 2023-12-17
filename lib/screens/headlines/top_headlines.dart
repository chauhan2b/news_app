import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/common/article_card.dart';
import 'package:news_app/common/article_loading_shimmer.dart';
import 'package:news_app/constants/constants.dart';
import 'package:news_app/repositories/news_repository.dart';

class TopHeadlines extends ConsumerStatefulWidget {
  const TopHeadlines({super.key});

  @override
  ConsumerState<TopHeadlines> createState() => _TopHeadlinesState();
}

class _TopHeadlinesState extends ConsumerState<TopHeadlines> {
  bool showFab = false;
  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    const pageKey = PageStorageKey('top-headlines');
    const duration = Duration(milliseconds: 300);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
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
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(
            topHeadlinesFutureProvider(page: 1).future,
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            return ListView.custom(
              key: pageKey,
              controller: scrollController,
              childrenDelegate: SliverChildBuilderDelegate(
                (context, index) {
                  // when index exceeds pageSize, page will increase by 1
                  final page = index ~/ pageSize + 1;
                  final indexInPage = index % pageSize;

                  final headlines =
                      ref.watch(topHeadlinesFutureProvider(page: page));

                  return headlines.when(
                    data: (headlines) {
                      if (indexInPage >= headlines.length) {
                        return null;
                      }

                      final headline = headlines[indexInPage];
                      return Column(
                        children: [
                          ArticleCard(article: headline),
                          const Divider(indent: 12.0, endIndent: 12.0),
                        ],
                      );
                    },
                    error: (error, stackTrace) {
                      if (index > 0) {
                        return null;
                      }

                      return Container(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () async => ref.refresh(
                                topHeadlinesFutureProvider(page: 1).future,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () {
                      return const ArticleLoadingShimmer();
                    },
                  );
                },
              ),
            );
          }),
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
