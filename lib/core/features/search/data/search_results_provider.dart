import 'dart:convert';
import 'dart:io';

import 'package:news_app/core/features/search/data/search_sort_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

import '../../../config/config.dart';
import '../../../constants/constants.dart';
import '../../article/article.dart';
import '../../article/news_response.dart';

part 'search_results_provider.g.dart';

@riverpod
FutureOr<List<Article>> searchResults(
  SearchResultsRef ref, {
  required String query,
  required int page,
}) async {
  final sortBy = ref.watch(searchSortProvider);

  // generating url with parameters
  final url = Uri(
    scheme: 'https',
    host: 'api.newscatcherapi.com',
    path: 'v2/search',
    queryParameters: {
      'q': query,
      'sort_by': sortBy.name,
      'lang': 'en',
      'page': page.toString(),
      'page_size': pageSize.toString(),
    },
  );

  try {
    final response =
        await http.get(url, headers: {'x-api-key': Config.newsCatcherApiKey});
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final newsResponse = NewsResponse.fromJson(body);
      return newsResponse.articles ?? [];
    } else {
      throw 'Error fetching news articles!';
    }
  } on SocketException {
    throw ('Unable to fetch articles. Check your internet connection and try again!');
  } catch (e) {
    rethrow;
  }
}
