class Forum {
  final int id;
  final String title;
  final String description;
  final String slug;
  final int subscriberCount;
  final String hardcodedImage;

  Forum({
    required this.id,
    required this.title,
    required this.description,
    required this.slug,
    required this.subscriberCount,
    required this.hardcodedImage,
  });

  factory Forum.fromJson(Map<String, dynamic> json) {
    final String cleanExcerpt = (json['excerpt']?['rendered'] ?? '')
        .replaceAll(RegExp(r'<[^>]*>|&nbsp;'), '')
        .trim();

    return Forum(
      id: json['id'] ?? 0,
      title: json['title']?['rendered'] ?? 'Sans titre',
      description: cleanExcerpt.isNotEmpty
          ? _shorten(cleanExcerpt)
          : 'Aucune description disponible.',
      slug: json['slug'] ?? '',
      subscriberCount: json['subscriber_count'] ?? 0,
      hardcodedImage: _getImageBySlug(json['slug'] ?? ''),
    );
  }

  /// Coupe à 150 caractères max pour l'affichage
  static String _shorten(String text) {
    return text.length > 150 ? '${text.substring(0, 150)}...' : text;
  }

  /// Image locale selon le slug
  static String _getImageBySlug(String slug) {
    if (slug.contains('patients')) {
      return 'assets/forum/patients.jpg';
    } else if (slug.contains('proches')) {
      return 'assets/forum/proches.jpg';
    } else if (slug.contains('survivants')) {
      return 'assets/forum/survivants.jpg';
    } else if (slug.contains('prevention')) {
      return 'assets/forum/prevention.jpg';
    } else if (slug.contains('endeuilles')) {
      return 'assets/forum/endeuilles.jpg';
    } else {
      return 'assets/forum/default.jpg';
    }
  }
}
