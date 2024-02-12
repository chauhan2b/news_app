import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/core/features/feed/data/domains_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

import '../../../constants/constants.dart';
import '../../article/article.dart';
import '../../article/news_response.dart';

part 'feed_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<Article>> myFeed(
  MyFeedRef ref, {
  required int page,
}) async {
  final domains = await ref.watch(domainsProvider.future);
  // generating url with parameters
  final url = Uri(
    scheme: 'https',
    host: 'api.newscatcherapi.com',
    path: 'v2/latest_headlines',
    queryParameters: {
      'sources': domains.join(','),
      'lang': 'en',
      'page_size': pageSize.toString(),
      'page': page.toString(),
    },
  );

  try {
    // check if domains are empty
    if (domains.isEmpty) {
      throw ('Nothing to display!\nTry adding at least one source.');
    }

    // fetch news articles
    final response =
        await http.get(url, headers: {'x-api-key': dotenv.env['API_KEY']!});
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final newsResponse = NewsResponse.fromJson(body);
      return newsResponse.articles ?? [];
    } else {
      final body = json.decode(response.body);
      if (body['error_code'] == "LimitReached") {
        throw "API limit reached";
      } else {
        throw 'Error fetching news articles!';
      }
    }
  } on SocketException {
    throw ('Unable to fetch your feed. Check your internet connection and try again!');
  } catch (e) {
    rethrow;
  }
}
