class Topic {
  final int id;
  final String title;
  final String? author;
  final DateTime date;
  final String? link;

  Topic({
    required this.id,
    required this.title,
    this.author,
    required this.date,
    this.link,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      date: DateTime.parse(json['date']),
      link: json['link'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'date': date.toIso8601String(),
      'link': link,
    };
  }
}
