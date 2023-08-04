import 'dart:convert';

import 'package:news_app/providers/sort_by_state.dart';
import 'package:news_app/providers/top_headlines_country.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/config.dart';
import 'package:http/http.dart' as http;

import '../models/news.dart';
import '../providers/category_provider.dart';
import '../providers/domains_state.dart';

part 'news_repository.g.dart';

class NewsRepository {
  Future<List<News>> fetchNews(List<String> domains) async {
    // generating url with parameters
    final url = Uri(
      scheme: 'https',
      host: 'newsapi.org',
      path: 'v2/everything',
      queryParameters: {
        'apiKey': Config.apiKey,
        'q': '',
        'domains': domains.join(','),
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

  Future<List<News>> fetchNewsByQuery(String query, SortBy sortBy) async {
    // generating url with parameters
    final url = Uri(
      scheme: 'https',
      host: 'newsapi.org',
      path: 'v2/everything',
      queryParameters: {
        'apiKey': Config.apiKey,
        'q': query,
        'sortBy': sortBy.name,
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

  Future<List<News>> fetchTopHeadlines(String country, String category) async {
    print(country);
    print(category);
    // generating url with parameters
    final url = Uri(
      scheme: 'https',
      host: 'newsapi.org',
      path: 'v2/top-headlines',
      queryParameters: {
        'apiKey': Config.apiKey,
        'country': country,
        'pageSize': '30',
        'category': category,
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
FutureOr<List<News>> newsListFuture(NewsListFutureRef ref) async {
  final domains = await ref.read(domainsProvider.notifier).get();
  return ref.read(newsRepositoryProvider).fetchNews(domains);
}

@riverpod
FutureOr<List<News>> searchResults(SearchResultsRef ref, String query) {
  final sortBy = ref.read(sortByStateProvider);
  print(sortBy);
  return ref.read(newsRepositoryProvider).fetchNewsByQuery(query, sortBy);
}

@Riverpod(keepAlive: true)
FutureOr<List<News>> topHeadlinesFuture(TopHeadlinesFutureRef ref) async {
  String country = await ref.read(countriesStateProvider.notifier).get();
  String category = await ref.read(categoryStateProvider.notifier).get();
  return ref.read(newsRepositoryProvider).fetchTopHeadlines(country, category);
}
