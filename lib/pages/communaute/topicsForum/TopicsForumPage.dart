import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/business/models/communaute/topic.dart';
import 'package:odc_mobile_template/pages/communaute/topicsForum/TopicsForumCtrl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../repliesTopic/RepliesTopicPage.dart';

class TopicsForumPage extends ConsumerStatefulWidget {
  final int forumId;
  final String forumName;

  const TopicsForumPage({
    Key? key,
    required this.forumId,
    required this.forumName,
  }) : super(key: key);

  @override
  ConsumerState<TopicsForumPage> createState() => _TopicsForumPageState();
}

class _TopicsForumPageState extends ConsumerState<TopicsForumPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(TopicsForumCtrlProvider.notifier).getTopicsForum(widget.forumId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B4397), Color(0xFF9C4D97)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      title: Text(
        'Forum : ${widget.forumName}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton.icon(
            onPressed: (){},
            icon: const Icon(Icons.favorite, color: Colors.red, size: 18),
            label: const Text(
              'Faire un don',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 4,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    final state = ref.watch(TopicsForumCtrlProvider);
    final topics = state.topics;
    final isLoading = state.isLoading ?? false;
    final error = state.error;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B4397)),
          strokeWidth: 3,
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red[400],
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Erreur de chargement',
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B4397),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () => ref.read(TopicsForumCtrlProvider.notifier)
                    .getTopicsForum(widget.forumId),
                child: const Text(
                  'Réessayer',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Section titre avec bande violette
        Container(
          margin: const EdgeInsets.only(left: 24, top: 24, bottom: 16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B4397), Color(0xFF9C4D97)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Sujets du forum',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 22,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Liste des sujets
        Expanded(
          child: topics.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.forum_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Aucun sujet disponible',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Soyez le premier à créer un sujet dans ce forum !',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          )
              : ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: topics.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final topic = topics[index];
              return _buildTopicCard(topic);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopicCard(Topic topic) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              topic.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${_formatDate(topic.date)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RepliesTopicPage(
                            topicId: topic.id,
                            topicName: topic.title,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.forum_outlined, size: 16),
                    label: const Text('Aller dans sujet'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF7B4397),
                      side: const BorderSide(color: Color(0xFF7B4397)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                if (topic.link != null) ...[
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final Uri url = Uri.parse(topic.link!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication, // Quitte l'app pour ouvrir dans le navigateur
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Impossible d\'ouvrir le lien')),
                        );
                      }
                    },
                    icon: const Icon(Icons.link, size: 16),
                    label: const Text('Lien'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      side: BorderSide(color: Colors.grey[600]!),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}