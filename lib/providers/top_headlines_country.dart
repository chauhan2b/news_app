import 'package:flutter_riverpod/flutter_riverpod.dart';

List<String> _countries = [
  'AUS',
  'CA',
  'IN',
  'JPN',
  'UK',
  'USA',
];

final countriesProvider = Provider<List<String>>((ref) {
  return _countries;
});
