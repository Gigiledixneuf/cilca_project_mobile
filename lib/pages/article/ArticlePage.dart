import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'ArticleCtrl.dart';
import 'ArticleState.dart';

class ArticlePage extends ConsumerStatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends ConsumerState<ArticlePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifier = ref.read(ArticleCtrlProvider.notifier);
      notifier.getCategories();
      notifier.getArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ArticleCtrlProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: _buildAppBar(state),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildFilterSection(state),
            const SizedBox(height: 32),
            _buildNewsCards(state),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ArticleState state) {
    final title = state.selectedCategory == null
        ? 'Explorer les articles'
        : 'Articles : ${state.selectedCategory}';

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
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton.icon(
            onPressed: _navigateToDonationPage,
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

  Widget _buildFilterSection(ArticleState state) {
    final selectedCategory = state.selectedCategory;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildCategoryChip(
            'Tous',
            isSelected: selectedCategory == null,
            onTap: () {
              ref.read(ArticleCtrlProvider.notifier).getArticles();
            },
          ),
          const SizedBox(width: 10),
          ...state.categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: _buildCategoryChip(
                category.name,
                isSelected: selectedCategory == category.name,
                onTap: () {
                  ref
                      .read(ArticleCtrlProvider.notifier)
                      .loadArticlesByCategory(category.name);
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
      String label, {
        required VoidCallback onTap,
        required bool isSelected,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [Color(0xFF7B4397), Color(0xFF9C4D97)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
              : null,
          color: isSelected ? null : Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: const Color(0xFF7B4397).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNewsCards(ArticleState state) {
    final articles = state.articles;
    final isLoadingArticles = state.isLoadingArticles ?? false;

    if (isLoadingArticles) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B4397)),
            strokeWidth: 3,
          ),
        ),
      );
    }

    if (state.error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(child: Text('Erreur: ${state.error}')),
      );
    }

    if (articles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: Text('Aucun article disponible')),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: articles.map((article) {
          return NewsCard(
            image: article.image,
            title: article.title,
            desc: article.desc,
            category: article.category,
            date: article.date,
            onTap: () => GoRouter.of(context).push('/public/articles/${article.id}'),
          );
        }).toList(),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String image;
  final String title;
  final String desc;
  final String category;
  final DateTime date;
  final VoidCallback onTap;

  const NewsCard({
    Key? key,
    required this.image,
    required this.title,
    required this.desc,
    required this.category,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = "${date.day}/${date.month}/${date.year}";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  image,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[100],
                    child: const Icon(
                      Icons.broken_image_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFF7B4397),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      desc,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Text(
                          'Lire la suite',
                          style: TextStyle(
                            color: Color(0xFF7B4397),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Color(0xFF7B4397),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
void _navigateToDonationPage() {
  print('Navigation vers la page de don');
}