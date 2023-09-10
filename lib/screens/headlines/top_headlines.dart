import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/repositories/news_repository.dart';
import 'package:news_app/common/articles_builder.dart';

class TopHeadlines extends ConsumerStatefulWidget {
  const TopHeadlines({super.key});

  @override
  ConsumerState<TopHeadlines> createState() => _TopHeadlinesState();
}

class _TopHeadlinesState extends ConsumerState<TopHeadlines> {
  bool showFab = false;
  @override
  Widget build(BuildContext context) {
    final futureHeadlines = ref.watch(topHeadlinesFutureProvider);
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
            return await ref.refresh(topHeadlinesFutureProvider);
          },
          child: futureHeadlines.when(
            data: (headlines) => ArticlesBuilder(
              articles: headlines,
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
