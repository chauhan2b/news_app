import 'package:freezed_annotation/freezed_annotation.dart';

part 'article.freezed.dart';
part 'article.g.dart';

@freezed
class Article with _$Article {
  const factory Article({
    required String title,
    required String author,
    @JsonKey(name: 'published_date') required DateTime publishedDate,
    required String link,
    @JsonKey(name: 'clean_url') required String cleanUrl,
    required String excerpt,
    required String summary,
    required String media,
    @JsonKey(name: '_id') required String id,
  }) = _Article;

  factory Article.fromJson(Map<String, Object?> json) =>
      _$ArticleFromJson(json);
}
