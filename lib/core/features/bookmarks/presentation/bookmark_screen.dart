import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/bookmarks_provider.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookmarks'),
        actions: [
          IconButton(
            onPressed: () {
              // show a confirmation dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Bookmarks'),
                  content: const Text(
                      'Are you sure you want to clear your bookmarks?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ref.read(bookmarksProvider.notifier).clearBookmarks();
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete_forever_outlined),
          ),
        ],
      ),
      body: bookmarksAsync.when(
        data: (bookmarks) => bookmarks.isEmpty
            ? const Center(
                child: Text('No bookmarks found'),
              )
            : ListView.builder(
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final bookmark = bookmarks[index];
                  return Dismissible(
                    key: Key(bookmark.id),
                    background: Container(
                      color: Colors.redAccent,
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 24.0),
                          child: Icon(
                            Icons.delete_outline,
                          ),
                        ),
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      ref
                          .read(bookmarksProvider.notifier)
                          .removeBookmark(bookmark);
                    },
                    child: GestureDetector(
                      onTap: () {
                        launchUrl(
                          Uri.parse(bookmark.url),
                          mode: LaunchMode.inAppBrowserView,
                        );
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                height: 80,
                                width: 100,
                                bookmark.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: primaryColor.withOpacity(0.05),
                                  height: 80,
                                  width: 100,
                                  child: const Icon(Icons.error_outline),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bookmark.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    bookmark.source,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
