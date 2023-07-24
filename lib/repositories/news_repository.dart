import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/config.dart';
import 'package:http/http.dart' as http;

import '../models/news.dart';

part 'news_repository.g.dart';

class NewsRepository {
  final apiKey = Config.apiKey;

  // TODO: Use to fetch news according to user's preference
  Future<List<News>> fetchNews() async {
    // final domains = newsParameters.domains.join(',');
    // final sortBy = newsParameters.sortBy.name;

    // generating url with parameters
    final url = Uri(
      scheme: 'https',
      host: 'newsapi.org',
      path: 'v2/everything',
      queryParameters: {
        'apiKey': apiKey,
        'q': '',
        'domains': 'ign.com',
        'sortBy': 'publishedAt',
        'language': 'en',
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
    // generating url with parameters
    final url = Uri(
      scheme: 'https',
      host: 'newsapi.org',
      path: 'v2/top-headlines',
      queryParameters: {
        'apiKey': apiKey,
        'country': 'in',
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

@riverpod
NewsRepository newsRepository(NewsRepositoryRef ref) {
  return NewsRepository();
}

@Riverpod(keepAlive: true)
FutureOr<List<News>> newsListFuture(NewsListFutureRef ref) {
  // final sortBy = ref.read(sortByStateProvider);
  return ref.read(newsRepositoryProvider).fetchNews();
}

@Riverpod(keepAlive: true)
FutureOr<List<News>> topHeadlinesFuture(TopHeadlinesFutureRef ref) {
  return ref.read(newsRepositoryProvider).fetchTopHeadlines();
}
