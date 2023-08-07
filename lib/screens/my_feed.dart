import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/routing/router.dart';

import '../widgets/articles_builder.dart';

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
    final futureNews = ref.watch(newsListFutureProvider);
    final scrollController = ScrollController();
    const pageKey = ValueKey('my-feed');
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
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            return ref.refresh(newsListFutureProvider);
          },
          child: futureNews.when(
            data: (news) => ArticlesBuilder(
              articles: news,
              controller: scrollController,
              pageKey: pageKey,
            ),
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
            loading: () => const Center(child: CircularProgressIndicator()),
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
