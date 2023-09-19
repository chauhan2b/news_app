import 'dart:convert';

class Article {
  final String title;
  final String author;
  final String publishedDate;
  final String link;
  final String excerpt;
  final String summary;
  final String topic;
  final String media;
  final String id;
  Article({
    required this.title,
    required this.author,
    required this.publishedDate,
    required this.link,
    required this.excerpt,
    required this.summary,
    required this.topic,
    required this.media,
    required this.id,
  });

  Article copyWith({
    String? title,
    String? author,
    String? publishedDate,
    String? link,
    String? excerpt,
    String? summary,
    String? topic,
    String? media,
    String? id,
  }) {
    return Article(
      title: title ?? this.title,
      author: author ?? this.author,
      publishedDate: publishedDate ?? this.publishedDate,
      link: link ?? this.link,
      excerpt: excerpt ?? this.excerpt,
      summary: summary ?? this.summary,
      topic: topic ?? this.topic,
      media: media ?? this.media,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'publishedDate': publishedDate,
      'link': link,
      'excerpt': excerpt,
      'summary': summary,
      'topic': topic,
      'media': media,
      'id': id,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      publishedDate: map['publishedDate'] ?? '',
      link: map['link'] ?? '',
      excerpt: map['excerpt'] ?? '',
      summary: map['summary'] ?? '',
      topic: map['topic'] ?? '',
      media: map['media'] ?? '',
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) =>
      Article.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Article(title: $title, author: $author, publishedDate: $publishedDate, link: $link, excerpt: $excerpt, summary: $summary, topic: $topic, media: $media, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Article &&
        other.title == title &&
        other.author == author &&
        other.publishedDate == publishedDate &&
        other.link == link &&
        other.excerpt == excerpt &&
        other.summary == summary &&
        other.topic == topic &&
        other.media == media &&
        other.id == id;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        author.hashCode ^
        publishedDate.hashCode ^
        link.hashCode ^
        excerpt.hashCode ^
        summary.hashCode ^
        topic.hashCode ^
        media.hashCode ^
        id.hashCode;
  }
}
