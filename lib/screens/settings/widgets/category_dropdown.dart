import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/category_state.dart';

class CategoryDropdown extends ConsumerWidget {
  const CategoryDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryStateProvider);
    return ListTile(
      leading: const Icon(Icons.category_outlined),
      title: const Text('Category'),
      trailing: DropdownButton<Category>(
        value: category,
        icon: const Icon(Icons.keyboard_arrow_down),
        onChanged: (val) {
          ref.read(categoryStateProvider.notifier).update(val!);
        },
        items: Category.values.map((Category val) {
          return DropdownMenuItem(
            value: val,
            child: Text(val.name),
          );
        }).toList(),
      ),
    );
  }
}
