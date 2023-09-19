import 'dart:convert';
import 'dart:io';

import 'package:news_app/constants/constants.dart';
import 'package:news_app/providers/sort_by_state.dart';
import 'package:news_app/providers/country_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/config.dart';
import 'package:http/http.dart' as http;

import '../models/news.dart';
import '../providers/category_state.dart';
import '../providers/domains_state.dart';

part 'news_repository.g.dart';

class NewsRepository {
  final String apiKey = Config.newsApiKey;

  Future<List<News>> fetchNews(List<String> domains, int page) async {
    // generating url with parameters
    final url = Uri(
      scheme: 'https',
      host: 'newsapi.org',
      path: 'v2/everything',
      queryParameters: {
        'apiKey': apiKey,
        'q': '',
        'domains': domains.join(','),
        'sortBy': 'publishedAt',
        'language': 'en',
        'pageSize': pageSize.toString(),
        'page': page.toString(),
      },
    );

    try {
      // check if domains are empty
      if (domains.isEmpty) {
        throw ('Nothing to display!\nTry adding at least one source.');
      }

      // fetch news articles
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
    } on SocketException {
      throw ('Unable to fetch your feed. Check your internet connection and try again!');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<News>> fetchNewsByQuery(
      String query, SortBy sortBy, int page) async {
    // generating url with parameters
    final url = Uri(
      scheme: 'https',
      host: 'newsapi.org',
      path: 'v2/everything',
      queryParameters: {
        'apiKey': apiKey,
        'q': query,
        'sortBy': sortBy.name,
        'language': 'en',
        'page': page.toString(),
        'pageSize': pageSize.toString(),
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
    } on SocketException {
      throw ('Unable to fetch articles. Check your internet connection and try again!');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<News>> fetchTopHeadlines(
      String country, String category, int page) async {
    // generating url with parameters
    final url = Uri(
      scheme: 'https',
      host: 'newsapi.org',
      path: 'v2/top-headlines',
      queryParameters: {
        'apiKey': apiKey,
        'country': country,
        'pageSize': pageSize.toString(),
        'page': page.toString(),
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
    } on SocketException {
      throw ('Unable to fetch headlines. Check your internet connection and try again!');
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
FutureOr<List<News>> newsListFuture(NewsListFutureRef ref,
    {required int page}) {
  final domains = ref.watch(domainsProvider);
  return ref.read(newsRepositoryProvider).fetchNews(domains, page);
}

@Riverpod(keepAlive: true)
FutureOr<List<News>> topHeadlinesFuture(TopHeadlinesFutureRef ref,
    {required int page}) {
  final country = ref.watch(countriesStateProvider);
  final category = ref.watch(categoryStateProvider);
  return ref
      .read(newsRepositoryProvider)
      .fetchTopHeadlines(country, category.name, page);
}

@riverpod
FutureOr<List<News>> searchResults(SearchResultsRef ref,
    {required String query, required int page}) {
  final sortBy = ref.watch(sortByStateProvider);
  return ref.read(newsRepositoryProvider).fetchNewsByQuery(query, sortBy, page);
}
