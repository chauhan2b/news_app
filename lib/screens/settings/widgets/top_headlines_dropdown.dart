import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/country_state.dart';

class TopHeadlinesDropdown extends ConsumerWidget {
  const TopHeadlinesDropdown({
    super.key,
    required this.country,
  });

  final String country;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countries = ref.watch(countriesProvider);
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Top headlines'),
      trailing: DropdownButton(
        value: country,
        icon: const Icon(Icons.keyboard_arrow_down),
        onChanged: (val) {
          ref.read(countriesStateProvider.notifier).updateCountry(val!);
        },
        items: countries.map((String val) {
          return DropdownMenuItem(
            value: val,
            child: Text(val.toUpperCase()),
          );
        }).toList(),
      ),
    );
  }
}
