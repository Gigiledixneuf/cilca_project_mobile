import 'package:html/parser.dart' as html_parser;

class Reply {
  final int id;
  final String content;
  final String author;
  final DateTime date;
  final String link;

  Reply({
    required this.id,
    required this.content,
    required this.author,
    required this.date,
    required this.link,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    final rawContent = json['content'] ?? '';
    final document = html_parser.parse(rawContent);
    final parsedText = document.body?.text ?? rawContent;

    return Reply(
      id: json['id'],
      content: parsedText,
      author: json['author'] ?? 'Inconnu',
      date: DateTime.parse(json['date']),
      link: json['link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author,
      'date': date.toIso8601String(),
      'link': link,
    };
  }
}
