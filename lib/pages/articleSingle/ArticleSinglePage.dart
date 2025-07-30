import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticleSinglePage extends StatelessWidget {
  const ArticleSinglePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final eventDate = DateTime(2025, 9, 24);
    final daysUntilEvent = eventDate.difference(now).inDays;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://example.com/path/to/cancer-awareness-image.jpg', // Replace with actual image
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Juvons-nous pour la marche connectée de sensibilisation aux cancers féminins !',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    'DU 24 SEPT. AU 08 OCT. NOUS COMPTONS SUR VOUS POUR LA\nMARCHE DES EVE',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.pink[800],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Main description
                  Text(
                    'Marche des Eve : du 24 septembre au 8 octobre 2025, marchons ensemble et pour elles !',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Date and share row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Il y a 1 j',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              // Share functionality
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.link),
                            onPressed: () {
                              // Copy link functionality
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 40),

                  // Countdown section
                  Center(
                    child: Text(
                      'C\'est dans $daysUntilEvent jours!!!!! Bloque tes agendas !',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Event details
                  const Text(
                    '- Du 24 septembre au 8 octobre 2025, marchons ensemble et pour elles !',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(text: 'Mon Réseau Cancer du Sein et '),
                        TextSpan(
                          text: 'Mon Réseau Gynéco',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[800],
                          ),
                        ),
                        const TextSpan(
                            text: ' vous invitent pour la 3ème édition de la '),
                        TextSpan(
                          text: 'Marche des Eve',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[800],
                          ),
                        ),
                        const TextSpan(text: ' !'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[800],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Registration action
                      },
                      child: const Text(
                        'JE M\'INSCRIS À LA MARCHE',
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
          ],
        ),
      ),
    );
  }
}