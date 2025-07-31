import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:odc_mobile_template/business/models/article/article.dart';
import 'package:odc_mobile_template/pages/articleSingle/ArticleSingleCtrl.dart';

class ArticleSinglePage extends ConsumerStatefulWidget {
  final int articleId;

  const ArticleSinglePage({Key? key, required this.articleId}) : super(key: key);

  @override
  ConsumerState<ArticleSinglePage> createState() => _ArticleSinglePageState();
}

class _ArticleSinglePageState extends ConsumerState<ArticleSinglePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(articleSingleCtrlProvider.notifier).getArticle(widget.articleId)
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr_FR');
    final state = ref.watch(articleSingleCtrlProvider);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Erreur: ${state.error}')),
      );
    }

    final article = state.article;
    if (article == null) {
      return const Scaffold(
        body: Center(child: Text('Article non trouvé')),
      );
    }

    final theme = Theme.of(context);
    final formattedDate = DateFormat.yMMMMd('fr_FR').format(article.date);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: Color(0xFF7B4397), // Couleur quand scrollé
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    article.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                  Container(color: Colors.black.withOpacity(0.4)),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(20),
              child: Container(
                height: 24,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF7B4397),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      article.category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        article.author ?? 'Auteur inconnu',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    article.desc,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (article.content != null)
                    Html(
                      data: article.content!,
                      style: {
                        "p": Style(
                          fontSize: FontSize.medium,
                          lineHeight: LineHeight.number(1.6),
                        ),
                        "figure": Style(
                          margin: Margins.only(bottom: 20),
                        ),
                        "img": Style(
                          padding: HtmlPaddings.only(bottom: 10),
                          alignment: Alignment.center,
                        ),
                        "iframe": Style(
                          width: Width(double.infinity),
                          height: Height(200),
                        ),
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}