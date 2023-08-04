// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_headlines_country.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$countriesHash() => r'406dfb2c02886180977085da617b7e6b72ba5011';

/// See also [countries].
@ProviderFor(countries)
final countriesProvider = AutoDisposeProvider<List<String>>.internal(
  countries,
  name: r'countriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$countriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CountriesRef = AutoDisposeProviderRef<List<String>>;
String _$countriesStateHash() => r'14800f49dc174d77df2683f0523dfe9014a37b48';

/// See also [CountriesState].
@ProviderFor(CountriesState)
final countriesStateProvider =
    AutoDisposeNotifierProvider<CountriesState, String>.internal(
  CountriesState.new,
  name: r'countriesStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$countriesStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CountriesState = AutoDisposeNotifier<String>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
