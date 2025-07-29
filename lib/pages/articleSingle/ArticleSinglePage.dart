import 'package:flutter/material.dart';

class ArticleDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final DateTime date;
  final String imageUrl;

   ArticleDetailPage({
    super.key,
    this.title = "Titre par défaut",
    this.content = "Contenu par défaut",
    DateTime? date,
    this.imageUrl = "https://picsum.photos/800/600",
  }) : date = date ?? DateTime.now();

  @override
  Widget build(BuildContext context) {
    final timeAgo = _formatTimeAgo(date);
    final eventDate = DateTime(2025, 9, 24);
    final daysUntilEvent = eventDate.difference(DateTime.now()).inDays;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 100),
                ),
              ),
            ),
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre principal
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Sous-titre en gras
                  const Text(
                    'DU 24 SEPT. AU 08 OCT. NOUS COMPTONS SUR VOUS POUR LA\nMARCHE DES EVE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date et actions
                  Row(
                    children: [
                      Text(
                        timeAgo,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.link),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Contenu
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  // Compte à rebours
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'C\'est dans $daysUntilEvent jours!!!!! Blaquez vos agendas !',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Liste à puces
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBulletPoint('Du 24 septembre au 8 octobre 2025, marchons ensemble et pour elles !'),
                      _buildBulletPoint('Mon Réseau Cancer du Sein et Mon Réseau Gynéco vous invitent pour la 3ème édition'),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Bouton de participation
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6B35),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'JE PARTICIPE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4.0, right: 8.0),
            child: Icon(Icons.circle, size: 8, color: Colors.orange),
          ),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} j';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} h';
    } else {
      return 'À l\'instant';
    }
  }
}