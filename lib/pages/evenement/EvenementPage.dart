// evenement_page.dart
import 'package:flutter/material.dart';

class Evenementpage extends StatefulWidget {
  const Evenementpage({super.key});

  @override
  State<Evenementpage> createState() => _EvenementPageState();
}

class _EvenementPageState extends State<Evenementpage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildFilterSection(),
            _buildNewsCards(), // À dynamiser dans le futur
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF7B4397),
      elevation: 0,
      title: const Text(
        'Evenement',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton.icon(
            onPressed: () {
              // Action don
            },
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
              size: 20,
            ),
            label: const Text(
              'Faire un don',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Bouton "Toutes" en orange
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // Action pour "Toutes"
                print('Toutes cliqué');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35), // Orange
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'Tous les Évènements',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Bouton "Évènements" en vert
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // Action pour "Évènements"
                print('Évènements cliqué');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50), // Vert
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'Calendrier',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget _buildNewsCards() {
    // ⚠️ Ici on affichera les articles dynamiquement plus tard
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          NewsCard(
            imageUrl: "https://images.pexels.com/photos/8385421/pexels-photo-8385421.jpeg",
            title: "Salon de proches",
            tag: "+ 200 membres",
            onTap: () => debugPrint("Card Actualité tapée"),
          ),

          NewsCard(
            imageUrl: "https://images.pexels.com/photos/8385421/pexels-photo-8385421.jpeg",
            title: "Salon de patients",
            tag: "+ 100 membres",
            onTap: () => debugPrint("Card Actualité tapée"),
          ),

          NewsCard(
            imageUrl: "https://images.pexels.com/photos/8385421/pexels-photo-8385421.jpeg",
            title: "Salon des survivants",
            tag: "+ 100 membres",
            onTap: () => debugPrint("Card Actualité tapée"),
          ),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String tag;
  final VoidCallback onTap;

  const NewsCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B6D1B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

