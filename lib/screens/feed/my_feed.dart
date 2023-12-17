import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/common/article_card.dart';
import 'package:news_app/common/article_loading_shimmer.dart';
import 'package:news_app/constants/constants.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/routing/router.dart';

class MyFeed extends ConsumerStatefulWidget {
  const MyFeed({super.key});

  @override
  ConsumerState<MyFeed> createState() => _MyFeedState();
}

class _MyFeedState extends ConsumerState<MyFeed> {
  bool showFab = false;
  bool isTyping = false;
  final focusNode = FocusNode();
  final controller = TextEditingController();

  void hideKeyboard() {
    setState(() {
      isTyping = false;
    });
    focusNode.unfocus();
  }

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    const pageKey = PageStorageKey('my-feed');
    const duration = Duration(milliseconds: 300);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: isTyping
            ? TextField(
                focusNode: focusNode,
                controller: controller,
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                onSubmitted: (value) {
                  hideKeyboard();
                  context.pushNamed(
                    AppRoute.searchResults.name,
                    queryParameters: {'query': value},
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search articles',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      controller.text == ''
                          ? hideKeyboard()
                          : controller.clear();
                    },
                    child: const Icon(Icons.close),
                  ),
                  border: InputBorder.none,
                ),
              )
            : const Text('My Feed'),
        actions: [
          isTyping
              ? Container()
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isTyping = true;
                    });
                  },
                ),
        ],
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          // hide fab when scrolling down and show when scrolling up
          final ScrollDirection direction = notification.direction;
          setState(() {
            if (direction == ScrollDirection.reverse) {
              showFab = false;
              if (isTyping) {
                hideKeyboard();
              }
            } else if (direction == ScrollDirection.forward) {
              showFab = true;
              if (isTyping) {
                hideKeyboard();
              }
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
            newsListFutureProvider(page: 1).future,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => ListView.custom(
              key: pageKey,
              controller: scrollController,
              // semanticChildCount: 99,
              childrenDelegate: SliverChildBuilderDelegate(
                (context, index) {
                  // when index exceeds pageSize, page will increase by 1
                  final page = index ~/ pageSize + 1;
                  final indexInPage = index % pageSize;

                  final articles =
                      ref.watch(newsListFutureProvider(page: page));

                  return articles.when(
                    data: (articles) {
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
                                newsListFutureProvider(page: 1).future,
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
