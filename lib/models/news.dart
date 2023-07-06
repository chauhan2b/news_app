import 'dart:convert';

class News {
  final String title;
  final String description;
  final String id;
  final String url;
  final String imageUrl;
  final String source;
  final String author;
  final DateTime publishedAt;

  News({
    required this.title,
    required this.description,
    required this.id,
    required this.url,
    required this.imageUrl,
    required this.source,
    required this.author,
    required this.publishedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'id': id,
      'url': url,
      'urlToImage': imageUrl,
      'source': {'name': source},
      'author': author,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      id: map['id'] ?? DateTime.now().toString(),
      url: map['url'] ?? '',
      imageUrl: map['urlToImage'] ??
          'https://www.salonlfc.com/wp-content/uploads/2018/01/image-not-found-1-scaled-1150x647.png',
      source: map['source']['name'] ?? '',
      author: map['author'] ?? '',
      publishedAt: DateTime.parse(map['publishedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory News.fromJson(String source) => News.fromMap(json.decode(source));
}
