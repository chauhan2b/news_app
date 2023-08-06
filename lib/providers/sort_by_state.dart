import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sort_by_state.g.dart';

enum SortBy {
  relevancy,
  popularity,
  publishedAt,
}

@Riverpod(keepAlive: true)
class SortByState extends _$SortByState {
  @override
  SortBy build() {
    return SortBy.publishedAt;
  }

  void update(SortBy sortBy) {
    state = sortBy;
  }
}
