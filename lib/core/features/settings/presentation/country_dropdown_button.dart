import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../headlines/data/headline_country_provider.dart';

class CountryDropdownButton extends ConsumerWidget {
  const CountryDropdownButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countriesList = ref.watch(countriesProvider);
    final countriesFuture = ref.watch(headlineCountryProvider);
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Country'),
      trailing: countriesFuture.when(
        data: (country) => DropdownButton(
          value: country,
          icon: const Icon(Icons.keyboard_arrow_down),
          onChanged: (val) {
            ref.read(headlineCountryProvider.notifier).updateCountry(val!);
          },
          items: countriesList.map((String val) {
            return DropdownMenuItem(
              value: val,
              child: Text(val.toUpperCase()),
            );
          }).toList(),
        ),
        error: (error, stackTrace) => const Text('Error'),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
