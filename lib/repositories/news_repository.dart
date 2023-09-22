import 'dart:convert';
import 'dart:io';

import 'package:news_app/constants/constants.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/models/news_response.dart';
import 'package:news_app/providers/sort_by_state.dart';
import 'package:news_app/providers/country_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/config.dart';
import 'package:http/http.dart' as http;

import '../providers/category_state.dart';
import '../providers/domains_state.dart';

part 'news_repository.g.dart';

class NewsRepository {
  static const apiKey = Config.newsCatcherApiKey;

  Future<List<Article>> fetchNews(List<String> domains, int page) async {
    // generating url with parameters
    final url = Uri(
      scheme: 'https',
      host: 'api.newscatcherapi.com',
      path: 'v2/latest_headlines',
      queryParameters: {
        'sources': domains.join(','),
        'lang': 'en',
        'page_size': pageSize,
        'page': page,
      },
    );

    try {
      // check if domains are empty
      if (domains.isEmpty) {
        throw ('Nothing to display!\nTry adding at least one source.');
      }

      // fetch news articles
      final response = await http.get(url, headers: {'x-api-key': apiKey});
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final newsResponse = NewsResponse.fromJson(body);
        return newsResponse.articles;
      } else {
        throw 'Error fetching news articles';
      }
    } on SocketException {
      throw ('Unable to fetch your feed. Check your internet connection and try again!');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Article>> fetchNewsByQuery(
      String query, SortBy sortBy, int page) async {
    // generating url with parameters
    final url = Uri(
      scheme: 'https',
      host: 'api.newscatcherapi.com',
      path: 'v2/search',
      queryParameters: {
        'q': query,
        'sort_by': sortBy.name,
        'lang': 'en',
        'page': page,
        'page_size': pageSize,
      },
    );

    try {
      final response = await http.get(url, headers: {'x-api-key': apiKey});
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final newsResponse = NewsResponse.fromJson(body);
        return newsResponse.articles;
      } else {
        throw 'Error fetching news articles';
      }
    } on SocketException {
      throw ('Unable to fetch articles. Check your internet connection and try again!');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Article>> fetchTopHeadlines(
      String country, String category, int page) async {
    // generating url with parameters
    final url = Uri(
      scheme: 'https',
      host: 'api.newscatcherapi.com',
      path: 'v2/latest_headlines',
      queryParameters: {
        'lang': 'en',
        'countries': country,
        'page_size': pageSize,
        'page': page,
        'topic': category,
      },
    );

    try {
      final response = await http.get(url, headers: {'x-api-key': apiKey});
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final newsResponse = NewsResponse.fromJson(body);
        return newsResponse.articles;
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
FutureOr<List<Article>> newsListFuture(NewsListFutureRef ref,
    {required int page}) {
  final domains = ref.watch(domainsProvider);
  return ref.read(newsRepositoryProvider).fetchNews(domains, page);
}

@Riverpod(keepAlive: true)
FutureOr<List<Article>> topHeadlinesFuture(TopHeadlinesFutureRef ref,
    {required int page}) {
  final country = ref.watch(countriesStateProvider);
  final category = ref.watch(categoryStateProvider);
  return ref
      .read(newsRepositoryProvider)
      .fetchTopHeadlines(country, category.name, page);
}

@riverpod
FutureOr<List<Article>> searchResults(SearchResultsRef ref,
    {required String query, required int page}) {
  final sortBy = ref.watch(sortByStateProvider);
  return ref.read(newsRepositoryProvider).fetchNewsByQuery(query, sortBy, page);
}
