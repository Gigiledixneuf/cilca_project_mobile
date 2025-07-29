class Article {
  final int id;
  final String title;
  final String desc;
  final String category;
  final DateTime date;
  final String image;

  // Champs optionnels pour l'affichage détaillé
  final String? content;
  final String? author;
  final String? link;

  Article({
    required this.id,
    required this.title,
    required this.desc,
    required this.category,
    required this.date,
    required this.image,
    this.content,
    this.author,
    this.link,
  });

  factory Article.fromJson(Map<String, dynamic> json, {required String imageUrl}) {
    // 🔹 Nettoyage et récupération du résumé (excerpt)
    final String rawExcerpt = json['excerpt']?['rendered'] ?? '';
    final String cleanDesc = rawExcerpt
        .replaceAll(RegExp(r'<[^>]*>'), '')     // Supprimer les balises HTML
        .replaceAll('&nbsp;', ' ')              // Nettoyer les entités HTML
        .replaceAll('&hellip;', '...')
        .trim();

    // 🔹 Récupération du contenu complet (HTML)
    final String? contentHtml = json['content']?['rendered'];

    // 🔹 Récupération du nom de l’auteur depuis l'objet _embedded
    final String? authorName = json['_embedded']?['author']?[0]?['name'];

    // 🔹 Récupération du lien permanent de l’article
    final String? link = json['link'];

    // 🔹 Récupération de la catégorie
    String categoryName = 'Non catégorisé';
    final wpTerms = json['_embedded']?['wp:term'];

    List<dynamic> flatTerms = [];

    if (wpTerms != null && wpTerms is List) {
      for (var group in wpTerms) {
        if (group is List) {
          flatTerms.addAll(group);
        }
      }
    }

    final categories = flatTerms.where((term) => term['taxonomy'] == 'category').toList();

    if (categories.isNotEmpty) {
      categoryName = categories.first['name'] ?? 'Non catégorisé';
    }

    // 🔹 Parsing de l'image à la une (featured media)
    String imageFinal = 'assets/communaute/default.jpg';

    if (json['_embedded']?['wp:featuredmedia'] != null &&
        json['_embedded']['wp:featuredmedia'].isNotEmpty) {
      String originalImageUrl = json['_embedded']['wp:featuredmedia'][0]['source_url'] ?? '';

      if (originalImageUrl.isNotEmpty) {
        try {
          // Extraire le chemin de l'URL originale
          Uri originalUri = Uri.parse(originalImageUrl);
          String path = originalUri.path.replaceAll(RegExp(r'/+'), '/');

          // Nettoyer la base de l'URL fournie en paramètre
          String cleanBaseUrl = imageUrl
              .replaceFirst(RegExp(r'^https?://'), '')
              .replaceAll(RegExp(r'/$'), '');

          // Recomposer l'URL complète de l'image
          imageFinal = 'http://$cleanBaseUrl$path';

          // Vérification que l'URL est bien formée
          if (!Uri.parse(imageFinal).isAbsolute) {
            throw FormatException('URL construite invalide');
          }

        } catch (e) {
          print('Erreur de transformation URL: $e - URL originale: $originalImageUrl');
          imageFinal = 'assets/communaute/default.jpg';
        }
      }
    }

    // 🔹 Parsing de la date de publication
    final postDate = DateTime.tryParse(json['date'] ?? '') ?? DateTime.now();

    // 🔹 Retour du modèle avec toutes les données extraites
    return Article(
      id: json['id'] ?? 0,
      title: json['title']?['rendered'] ?? 'Sans titre',
      desc: cleanDesc,
      category: categoryName,
      date: postDate,
      image: imageFinal,
      content: contentHtml,
      author: authorName,
      link: link,
    );
  }

  // 🔹 Conversion du modèle en JSON (utile pour stockage local éventuel)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'category': category,
      'date': date.toIso8601String(),
      'image': image,
      'content': content,
      'author': author,
      'link': link,
    };
  }
}
