import 'package:odc_mobile_template/business/models/article/article.dart';

class ArticleState {
  final List<Article> articles;
  final bool? isLoading;
  final String? error;

  ArticleState({
    required this.articles,
    this.isLoading,
    this.error,
  });

  factory ArticleState.initial() {
    return ArticleState(
      articles : [],
      isLoading: false,
      error: null,
    );
  }

  ArticleState copyWith({
    List<Article>? articles,
    bool? isLoading,
    String? error,
  }) {
    return ArticleState(
      articles : articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
