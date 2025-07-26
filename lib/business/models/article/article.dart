class Article {
  final int id;
  final String title;
  final String desc;
  final String category;
  final DateTime date;
  final String image;

  Article({
    required this.id,
    required this.title,
    required this.desc,
    required this.category,
    required this.date,
    required this.image,
  });

  factory Article.fromJson(Map<String, dynamic> json, {required String imageUrl}) {
    final String rawExcerpt = json['excerpt']?['rendered'] ?? '';
    final String cleanDesc = rawExcerpt
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&hellip;', '...')
        .trim();

    // ✅ Bloc corrigé : parsing sécurisé des catégories
    String categoryName = '';
    final wpTerms = json['_embedded']?['wp:term'];

    List<dynamic> flatTerms = [];

    if (wpTerms != null && wpTerms is List) {
      for (var group in wpTerms) {
        if (group is List) {
          flatTerms.addAll(group);
        }
      }
    }

    final categories = flatTerms
        .where((term) => term['taxonomy'] == 'category')
        .toList();

    if (categories.isNotEmpty) {
      categoryName = categories.first['name'] ?? '';
    }

    // ✅ Image mise en avant
    String imageFinal = '';
    if (json['_embedded']?['wp:featuredmedia'] != null &&
        json['_embedded']['wp:featuredmedia'].isNotEmpty) {
      imageFinal = json['_embedded']['wp:featuredmedia'][0]['source_url'] ?? '';

      // Remplacer localhost
      if (imageFinal.contains('localhost')) {
        imageFinal = imageFinal.replaceFirst('http://localhost', imageUrl);
      }
    }

    // ✅ Date
    final postDate = DateTime.tryParse(json['date'] ?? '') ?? DateTime.now();

    return Article(
      id: json['id'] ?? 0,
      title: json['title']?['rendered'] ?? 'Sans titre',
      desc: cleanDesc,
      category: categoryName,
      date: postDate,
      image: imageFinal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'category': category,
      'date': date.toIso8601String(),
      'image': image,
    };
  }
}
