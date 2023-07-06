import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/config.dart';
import 'package:http/http.dart' as http;

import '../models/news.dart';

class NewsRepository {
  final apiKey = Config.apiKey;

  Future<List<News>> fetchNews() async {
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        // convert each json article into list of article
        return List<News>.from(
          body['articles'].map((article) => News.fromMap(article)),
        );
      } else {
        throw 'Error fetching news articles';
      }
    } catch (e) {
      rethrow;
    }
  }
}

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepository();
});

final newsListFutureProvider = FutureProvider<List<News>>((ref) async {
  final newsRepository = ref.read(newsRepositoryProvider);
  return newsRepository.fetchNews();
});
