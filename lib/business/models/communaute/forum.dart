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
    final String rawContent = json['content']?['rendered'] ?? '';
    final String cleanDescription = rawContent
        .replaceAll(RegExp(r'<[^>]*>'), '')     // Supprime les balises HTML
        .replaceAll('&nbsp;', ' ')              // Remplace &nbsp; par un espace
        .replaceAll('&rsquo;', '’')             // Remplace les guillemets typographiques
        .replaceAll('&amp;', '&')               // Remplace &
        .replaceAll('&lt;', '<')                // Remplace <
        .replaceAll('&gt;', '>')                // Remplace >
        .trim();

    return Forum(
      id: json['id'] ?? 0,
      title: json['title']?['rendered'] ?? 'Sans titre',
      description: cleanDescription,
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
      return 'assets/communaute/patients.jpg';
    } else if (slug.contains('proches')) {
      return 'assets/communaute/proches.jpg';
    } else if (slug.contains('survivants')) {
      return 'assets/communaute/survivants.jpg';
    } else if (slug.contains('prevention')) {
      return 'assets/communaute/prevention.jpg';
    } else if (slug.contains('endeuilles')) {
      return 'assets/communaute/default.jpg';
    } else {
      return 'assets/communaute/default.jpg';
    }
  }
}
