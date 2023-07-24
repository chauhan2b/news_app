import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/repositories/news_repository.dart';

import '../widgets/show_dialog_box.dart';
import '../widgets/articles_builder.dart';

class MyFeed extends ConsumerStatefulWidget {
  const MyFeed({super.key});

  @override
  ConsumerState<MyFeed> createState() => _MyFeedState();
}

class _MyFeedState extends ConsumerState<MyFeed> {
  bool showFab = false;
  @override
  Widget build(BuildContext context) {
    final futureNews = ref.watch(newsListFutureProvider);
    final scrollController = ScrollController();
    const pageKey = ValueKey('my-feed');
    const duration = Duration(milliseconds: 300);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              showDialogBox(context, ref);
            },
          ),
        ],
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
            error: (error, stackTrace) => Center(child: Text(error.toString())),
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
                scrollController.jumpTo(position);
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
