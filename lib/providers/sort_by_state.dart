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
// SortBy sortByState(SortByStateRef ref) {
//   return SortBy.publishedAt;
// }
