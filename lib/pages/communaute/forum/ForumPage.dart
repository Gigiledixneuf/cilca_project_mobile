import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/business/models/communaute/forum.dart';

import 'ForumCtrl.dart';

class ForumPage extends ConsumerStatefulWidget {
  const ForumPage({super.key});

  @override
  ConsumerState<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends ConsumerState<ForumPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(ForumCtrlProvider.notifier).getForums());
  }

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
            const SizedBox(height: 40,),
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  color: Color(0xFF7B4397),
                ),
                const SizedBox(width: 12,),
                Text(
                  'Rejoindre un salon',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            _buildForumCards(),
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
        'Communauté',
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
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Tous les forums',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForumCards() {
    final state = ref.watch(ForumCtrlProvider);
    final forums = state.forums;
    final isLoading = state.isLoading ?? false;
    final error = state.error;

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          error,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (forums.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Aucun forum disponible pour le moment."),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: forums.map((forum) {
          return ForumCard(
            forum: forum,
            onTap: () {
              debugPrint("Forum tapé : ${forum.title}");
              // Tu peux naviguer ici vers une page de sujets
              // Navigator.push(...);
            },
          );
        }).toList(),
      ),
    );
  }
}

class ForumCard extends StatelessWidget {
  final Forum forum;
  final VoidCallback onTap;

  const ForumCard({
    super.key,
    required this.forum,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                forum.hardcodedImage,
                height: 180,
                fit: BoxFit.cover,
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
                    forum.title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    forum.description,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      height: 1.4,
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
                        forum.subscriberCount == 0
                            ? 'Aucun membre disponible'
                            : '+ ${forum.subscriberCount} membres',
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
