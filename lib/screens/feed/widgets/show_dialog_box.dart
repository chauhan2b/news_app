import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/sort_by_state.dart';

Future<void> showDialogBox(BuildContext context, WidgetRef ref) {
  final sortBy = ref.watch(sortByStateProvider);

  void updateSortBy(SortBy value) {
    ref.read(sortByStateProvider.notifier).update(value);
    context.pop();
  }

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Sort by'),
          children: [
            RadioListTile(
              title: const Text('Relevancy'),
              value: SortBy.relevancy,
              groupValue: sortBy,
              onChanged: (value) {
                updateSortBy(value!);
              },
            ),
            RadioListTile(
              title: const Text('Popularity'),
              value: SortBy.rank,
              groupValue: sortBy,
              onChanged: (value) {
                updateSortBy(value!);
              },
            ),
            RadioListTile(
              title: const Text('Latest'),
              value: SortBy.date,
              groupValue: sortBy,
              onChanged: (value) {
                updateSortBy(value!);
              },
            ),
          ],
        );
      });
}
