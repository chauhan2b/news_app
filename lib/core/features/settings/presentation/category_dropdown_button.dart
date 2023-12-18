import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../headlines/data/headline_category_provider.dart';

class CategoryDropdownButton extends ConsumerWidget {
  const CategoryDropdownButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryFuture = ref.watch(headlineCategoryProvider);
    return ListTile(
      leading: const Icon(Icons.category_outlined),
      title: const Text('Category'),
      trailing: categoryFuture.when(
        data: (category) => DropdownButton<Category>(
          value: category,
          icon: const Icon(Icons.keyboard_arrow_down),
          onChanged: (val) {
            ref.read(headlineCategoryProvider.notifier).updateCategory(val!);
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
