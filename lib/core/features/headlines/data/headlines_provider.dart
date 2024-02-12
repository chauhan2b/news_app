import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/core/features/headlines/data/headline_category_provider.dart';
import 'package:news_app/core/features/headlines/data/headline_country_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

import '../../../constants/constants.dart';
import '../../article/article.dart';
import '../../article/news_response.dart';

part 'headlines_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<Article>> headlines(HeadlinesRef ref, {required int page}) async {
  final country = await ref.watch(headlineCountryProvider.future);
  final category = await ref.watch(headlineCategoryProvider.future);

  // generating url with parameters
  final url = Uri(
    scheme: 'https',
    host: 'api.newscatcherapi.com',
    path: 'v2/latest_headlines',
    queryParameters: {
      'lang': 'en',
      'countries': country,
      'page_size': pageSize.toString(),
      'page': page.toString(),
      'topic': category.name,
    },
  );

  try {
    final response =
        await http.get(url, headers: {'x-api-key': dotenv.env['API_KEY']!});
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final newsResponse = NewsResponse.fromJson(body);
      return newsResponse.articles ?? [];
    } else {
      final body = json.decode(response.body);
      if (body['error_code'] == "LimitReached") {
        throw "API limit reached: ${body['message']}";
      } else {
        throw 'Error fetching news articles!';
      }
    }
  } on SocketException {
    throw ('Unable to fetch headlines. Check your internet connection and try again!');
  } catch (e) {
    rethrow;
  }
}
