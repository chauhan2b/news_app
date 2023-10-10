import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sort_by_state.g.dart';

enum SortBy {
  relevancy,
  date,
  rank,
}

@Riverpod(keepAlive: true)
class SortByState extends _$SortByState {
  @override
  SortBy build() {
    return SortBy.relevancy;
  }

  void updateSortBy(SortBy sortBy) {
    state = sortBy;
  }
}
