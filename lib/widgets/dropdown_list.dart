import 'package:flutter/material.dart';

class DropdownList<T> extends StatelessWidget {
  final String title;
  final Icon icon;
  final List<DropdownMenuItem<T>> items;
  final T value;
  final ValueChanged<T?> onChanged;

  const DropdownList({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.category_outlined),
      title: Text(title),
      trailing: DropdownButton<T>(
        value: value,
        icon: icon,
        onChanged: onChanged,
        items: items,
      ),
    );
  }
}
