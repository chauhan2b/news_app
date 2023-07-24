import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortBy {
  relevancy,
  popularity,
  publishedAt,
}

class NewsParameters {
  NewsParameters({
    // required this.domains,
    required this.sortBy,
  });

  // List<String> domains;
  SortBy sortBy;
}

final sortByStateProvider = StateProvider<SortBy>((ref) {
  return SortBy.popularity;
});
