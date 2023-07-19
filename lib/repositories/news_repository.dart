import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/config.dart';
import 'package:http/http.dart' as http;

import '../models/news.dart';

class NewsRepository {
  final apiKey = Config.apiKey;

  // TODO: Use to fetch news according to user's preference
  Future<List<News>> fetchNews() async {
    final url = Uri(
      scheme: 'https',
      host: 'newsapi.org',
      path: 'v2/everything',
      queryParameters: {
        'apiKey': apiKey,
        'q': '',
        'domains': 'ign.com',
        'language': 'en',
        'sortBy': 'publishedAt',
      },
    );

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

  Future<List<News>> fetchTopHeadlines() async {
    final url = Uri(
      scheme: 'https',
      host: 'newsapi.org',
      path: 'v2/top-headlines',
      queryParameters: {
        'apiKey': apiKey,
        'country': 'us',
        'pageSize': '30',
      },
    );

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

final topHeadlinesFutureProvider = FutureProvider<List<News>>((ref) async {
  final newsRepository = ref.read(newsRepositoryProvider);
  return newsRepository.fetchTopHeadlines();
});
