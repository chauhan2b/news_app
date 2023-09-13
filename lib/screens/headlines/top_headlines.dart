import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/common/article_card.dart';
import 'package:news_app/constants/constants.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:shimmer/shimmer.dart';

class TopHeadlines extends ConsumerStatefulWidget {
  const TopHeadlines({super.key});

  @override
  ConsumerState<TopHeadlines> createState() => _TopHeadlinesState();
}

class _TopHeadlinesState extends ConsumerState<TopHeadlines> {
  bool showFab = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).colorScheme.primary;

    final scrollController = ScrollController();
    const pageKey = ValueKey('top-headlines');
    const duration = Duration(milliseconds: 300);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          final ScrollDirection direction = notification.direction;
          setState(() {
            if (direction == ScrollDirection.reverse) {
              showFab = false;
            } else if (direction == ScrollDirection.forward) {
              showFab = true;
            }
          });

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
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            return await ref.refresh(topHeadlinesFutureProvider(page: 1));
          },
          child: ListView.custom(
            key: pageKey,
            controller: scrollController,
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) {
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
                  error: (error, stackTrace) => LayoutBuilder(
                    builder: (context, constraints) {
                      return ListView(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Center(
                              child: Text(
                                error.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  loading: () {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Shimmer.fromColors(
                        baseColor: primaryColor.withOpacity(0.05),
                        highlightColor: primaryColor.withOpacity(0.2),
                        child: Column(
                          children: [
                            Container(
                              height: size.height * 0.24,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 24,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 24,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
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
