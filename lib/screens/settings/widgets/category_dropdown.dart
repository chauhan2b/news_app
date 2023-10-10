import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/category_state.dart';

class CategoryDropdown extends ConsumerWidget {
  const CategoryDropdown({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryFuture = ref.watch(categoryStateProvider);
    return ListTile(
      leading: const Icon(Icons.category_outlined),
      title: const Text('Category'),
      trailing: categoryFuture.when(
        data: (category) => DropdownButton<Category>(
          value: category,
          icon: const Icon(Icons.keyboard_arrow_down),
          onChanged: (val) {
            ref.read(categoryStateProvider.notifier).updateCategory(val!);
          },
          items: Category.values.map((Category val) {
            return DropdownMenuItem(
              value: val,
              child: Text(val.name),
            );
          }).toList(),
        ),
        error: (error, stackTrace) => const Text('Error'),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
