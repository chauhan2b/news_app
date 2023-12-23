import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark.freezed.dart';
part 'bookmark.g.dart';

@freezed
class Bookmark with _$Bookmark {
  const factory Bookmark({
    required String title,
    required String url,
    required String imageUrl,
    required String source,
    required String id,
  }) = _Bookmark;

  factory Bookmark.fromJson(Map<String, Object?> json) =>
      _$BookmarkFromJson(json);
}
