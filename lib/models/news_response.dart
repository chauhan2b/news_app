import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_app/models/article.dart';

part 'news_response.freezed.dart';
part 'news_response.g.dart';

@freezed
class NewsResponse with _$NewsResponse {
  const factory NewsResponse({
    required String status,
    @JsonKey(name: 'total_hits') required int totalHits,
    required int page,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'page_size') required int pageSize,
    required List<Article>? articles,
  }) = _NewsResponse;

  factory NewsResponse.fromJson(Map<String, Object?> json) =>
      _$NewsResponseFromJson(json);
}
