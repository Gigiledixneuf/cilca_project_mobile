import '../../business/models/article/article.dart';
import '../../business/models/article/category.dart';

class ArticleState {
  final bool isLoadingArticles;
  final bool isLoadingCategories;
  final String? error;
  final List<Article> articles;
  final List<ArticleCategory> categories;
  final String? selectedCategory;

  ArticleState({
    this.isLoadingArticles = false,
    this.isLoadingCategories = false,
    this.error,
    this.articles = const [],
    this.categories = const [],
    this.selectedCategory,
  });

  ArticleState copyWith({
    bool? isLoadingArticles,
    bool? isLoadingCategories,
    String? error,
    List<Article>? articles,
    List<ArticleCategory>? categories,
    String? selectedCategory,
  }) {
    return ArticleState(
      isLoadingArticles: isLoadingArticles ?? this.isLoadingArticles,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      error: error ?? this.error,
      articles: articles ?? this.articles,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory,
    );
  }
}
