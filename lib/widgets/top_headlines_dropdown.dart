import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/top_headlines_country.dart';

class TopHeadlinesDropdown extends ConsumerStatefulWidget {
  const TopHeadlinesDropdown({
    super.key,
  });

  @override
  ConsumerState<TopHeadlinesDropdown> createState() =>
      _TopHeadlinesDropdownState();
}

class _TopHeadlinesDropdownState extends ConsumerState<TopHeadlinesDropdown> {
  String dropDownValue = 'AUS';

  @override
  Widget build(BuildContext context) {
    final countries = ref.watch(countriesProvider);
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Top headlines'),
      trailing: DropdownButton(
        value: dropDownValue,
        icon: const Icon(Icons.keyboard_arrow_down),
        onChanged: (val) {
          setState(() {
            dropDownValue = val!;
          });
        },
        items: countries.map((String val) {
          return DropdownMenuItem(
            value: val,
            child: Text(val),
          );
        }).toList(),
      ),
    );
  }
}
