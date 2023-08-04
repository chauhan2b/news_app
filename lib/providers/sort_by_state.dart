import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortBy {
  relevancy,
  popularity,
  publishedAt,
}

final sortByStateProvider = StateProvider<SortBy>((ref) {
  return SortBy.publishedAt;
});

// @riverpod
// class SortByState extends _$SortByState {
//   @override
//   SortBy build() {
//     return SortBy.publishedAt;
//   }

//   void update(SortBy sortBy) {
//     state = sortBy;
//   }
// }
