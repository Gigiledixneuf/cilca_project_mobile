import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../business/models/communaute/reply.dart';
import 'RepliesTopicCtrl.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF7B4397);
  static const Color secondaryPurple = Color(0xFF8B5CF6);
  static const Color accentOrange = Color(0xFF7B4397);
  static const Color lightPurple = Color(0xFFF3F4F6);
  static const Color cardBorderGrey = Color(0xFFCCCCCC);
}

class RepliesTopicPage extends ConsumerStatefulWidget {
  final int topicId;
  final String topicName;

  const RepliesTopicPage({
    Key? key,
    required this.topicId,
    required this.topicName,
  }) : super(key: key);

  @override
  ConsumerState<RepliesTopicPage> createState() => _RepliesTopicPageState();
}

class _RepliesTopicPageState extends ConsumerState<RepliesTopicPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _localeInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null).then((_) {
      setState(() {
        _localeInitialized = true;
      });
      ref.read(RepliesTopicCtrlProvider.notifier).getRepliesTopic(widget.topicId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(RepliesTopicCtrlProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        title: Text('Sujet : ${widget.topicName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(RepliesTopicCtrlProvider.notifier).getRepliesTopic(widget.topicId);
            },
          )
        ],
      ),
      body: !_localeInitialized
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Header avec nombre de messages
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.lightPurple,
            child: Row(
              children: [
                const Icon(Icons.forum, color: AppColors.primaryPurple),
                const SizedBox(width: 8),
                Text(
                  'Vous lisez ${state.replies.length} fils de discussion',
                  style: const TextStyle(
                    color: AppColors.primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Liste des réponses
          Expanded(
            child: state.isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                ? Center(
              child: Text(
                state.error ?? '',
                style: const TextStyle(color: Colors.red),
              ),
            )
                : state.replies.isEmpty
                ? const Center(
              child: Text(
                'Aucune réponse trouvée.',
                style: TextStyle(color: Colors.black54),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.replies.length,
              itemBuilder: (context, index) {
                final reply = state.replies[index];
                return _buildReplyCard(reply);
              },
            ),
          ),

          // Section d'envoi de commentaire
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildReplyCard(Reply reply) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.cardBorderGrey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primaryPurple,
                    child: Icon(
                      Icons.person,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    reply.author,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat.yMMMd('fr_FR').add_Hm().format(reply.date),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            reply.content,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Écrire un commentaire...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.cardBorderGrey),
                ),
                filled: true,
                fillColor: AppColors.lightPurple,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              minLines: 1,
              maxLines: 3,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.secondaryPurple,
            child: IconButton(
              onPressed: () {
                final comment = _commentController.text.trim();
                if (comment.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fonction d\'envoi pas encore implémentée'),
                      backgroundColor: AppColors.accentOrange,
                    ),
                  );
                  _commentController.clear();
                }
              },
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}