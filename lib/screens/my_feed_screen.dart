import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/repositories/news_repository.dart';

class MyFeedScreen extends ConsumerWidget {
  const MyFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsList = ref.watch(newsListFutureProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your feed'),
      ),
      body: newsList.when(
        data: (news) => ListView.separated(
          separatorBuilder: (context, index) =>
              const Divider(indent: 12.0, endIndent: 12.0),
          itemCount: news.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    news[index].imageUrl,
                    fit: BoxFit.cover,
                    height: size.height * 0.26,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    news[index].title,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 6.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(news[index].source),
                  ),
                ),
              ],
            ),
          ),
        ),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
