class ArticleCategory {
  final int id;
  final String name;
  final String slug;

  ArticleCategory({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory ArticleCategory.fromJson(Map<String, dynamic> json) {
    return ArticleCategory(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}
