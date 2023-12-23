import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/core/features/bookmarks/data/bookmarks_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../features/article/article.dart';
import '../features/bookmarks/domain/bookmark.dart';

class ArticleCard extends ConsumerWidget {
  final Article article;
  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    final dateTime =
        DateTime.now().difference(article.publishedDate ?? DateTime.now());
    final articleDate = DateTime.now().subtract(dateTime);
    return InkWell(
      // onLongPress: () {
      //   showModalBottomSheet(
      //     showDragHandle: true,
      //     isScrollControlled: true,
      //     context: context,
      //     builder: (context) => Padding(
      //       padding: const EdgeInsets.only(
      //         left: 24.0,
      //         right: 24.0,
      //         bottom: 24.0,
      //       ),
      //       child: SingleChildScrollView(
      //         child: Column(
      //           children: [
      //             const Text(
      //               'Summary (Beta)',
      //               style: TextStyle(fontSize: 18.0),
      //             ),
      //             const Divider(),
      //             Text(
      //               article.summary == null || article.summary!.isEmpty
      //                   ? 'No summary found'
      //                   : article.summary!.replaceAll('\n', ''),
      //               textAlign: TextAlign.justify,
      //             ),
      //             const SizedBox(
      //               height: 30,
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   );
      // },
      onTap: article.link == null || article.link!.isEmpty
          ? null
          : () async {
              if (!await launchUrl(
                Uri.parse(article.link!),
                mode: LaunchMode.externalApplication,
              )) {
                throw Exception('Could not launch');
              }
            },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: article.media == null || article.media!.isEmpty
                  ? Container(
                      color: primaryColor.withOpacity(0.05),
                      height: size.height * 0.24,
                      width: double.infinity,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.error),
                          Text('Image not found'),
                        ],
                      ),
                    )
                  : Image.network(
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return SizedBox(
                          height: size.height * 0.24,
                          width: double.infinity,
                          child: Shimmer.fromColors(
                            baseColor: primaryColor.withOpacity(0.05),
                            highlightColor: primaryColor.withOpacity(0.2),
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: primaryColor.withOpacity(0.05),
                        height: size.height * 0.24,
                        width: double.infinity,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.error),
                            Text('Could not load image'),
                          ],
                        ),
                      ),
                      article.media!,
                      fit: BoxFit.cover,
                      height: size.height * 0.24,
                      width: double.infinity,
                    ),
            ),
            const SizedBox(height: 12.0),
            Text(
              article.title ?? 'No title found',
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 18.0,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            // const SizedBox(height: 6.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${article.cleanUrl} | ${timeago.format(articleDate, locale: 'en_short')}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_outline),
                  onPressed: () {
                    final bookmark = Bookmark(
                      title: article.title ?? '',
                      url: article.link ?? '',
                      imageUrl: article.media ?? '',
                      source: article.cleanUrl ?? '',
                      id: article.id ?? '',
                    );
                    ref.read(bookmarksProvider.notifier).saveBookmark(bookmark);
                  },
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.share_outlined),
                  onPressed: article.link == null || article.link!.isEmpty
                      ? null
                      : () {
                          Share.share(article.link!);
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
