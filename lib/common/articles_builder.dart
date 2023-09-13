import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/news.dart';

class ArticlesBuilder extends StatelessWidget {
  const ArticlesBuilder({
    super.key,
    required this.articles,
    required this.controller,
    required this.pageKey,
  });

  final List<News> articles;
  final ScrollController controller;
  final ValueKey pageKey;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return articles.isEmpty
        ? const Center(
            child: Text(
              'No articles found',
              style: TextStyle(fontSize: 26.0),
            ),
          )
        : ListView.separated(
            key: PageStorageKey(pageKey),
            controller: controller,
            separatorBuilder: (context, index) =>
                const Divider(indent: 12.0, endIndent: 12.0),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              final dateTime = DateTime.now().difference(article.publishedAt);
              final articleDate = DateTime.now().subtract(dateTime);
              return InkWell(
                onTap: () async {
                  if (!await launchUrl(
                    Uri.parse(article.url),
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
                        child: Image.network(
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return SizedBox(
                              height: size.height * 0.26,
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
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: primaryColor.withOpacity(0.05),
                            height: size.height * 0.26,
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
                          article.imageUrl,
                          fit: BoxFit.cover,
                          height: size.height * 0.26,
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        article.title,
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
                              '${article.source} | ${timeago.format(articleDate, locale: 'en_short')}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.share_outlined),
                            onPressed: () {
                              Share.share(article.url);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
  }
}
