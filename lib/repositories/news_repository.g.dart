// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newsRepositoryHash() => r'5cd4c431e76e54100ee36f4ac9b1b762edfa1895';

/// See also [newsRepository].
@ProviderFor(newsRepository)
final newsRepositoryProvider = AutoDisposeProvider<NewsRepository>.internal(
  newsRepository,
  name: r'newsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$newsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NewsRepositoryRef = AutoDisposeProviderRef<NewsRepository>;
String _$newsListFutureHash() => r'17e574268e1fae870d86ac2316787f86345ec457';

/// See also [newsListFuture].
@ProviderFor(newsListFuture)
final newsListFutureProvider = FutureProvider<List<News>>.internal(
  newsListFuture,
  name: r'newsListFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$newsListFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NewsListFutureRef = FutureProviderRef<List<News>>;
String _$topHeadlinesFutureHash() =>
    r'7252d05be642b56862ccf4697d9ce08f0075e9d5';

/// See also [topHeadlinesFuture].
@ProviderFor(topHeadlinesFuture)
final topHeadlinesFutureProvider = FutureProvider<List<News>>.internal(
  topHeadlinesFuture,
  name: r'topHeadlinesFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$topHeadlinesFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TopHeadlinesFutureRef = FutureProviderRef<List<News>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
