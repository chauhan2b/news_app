import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_sort_provider.g.dart';

enum SortBy {
  relevancy,
  date,
  rank,
}

@Riverpod(keepAlive: true)
class SearchSort extends _$SearchSort {
  @override
  SortBy build() {
    return SortBy.relevancy;
  }

  void updateSortBy(SortBy sortBy) {
    state = sortBy;
  }
}
