enum SortBy {
  relevancy,
  popularity,
  publishedAt,
}

class NewsParameters {
  NewsParameters({
    required this.domains,
    required this.sortBy,
  });

  List<String> domains;
  SortBy sortBy;
}
