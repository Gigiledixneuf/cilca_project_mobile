import '../../business/models/article/article.dart';

class ArticleSingleState {
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final Article? article;

  ArticleSingleState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
    this.article,
  });

  ArticleSingleState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    Article? article,
  }) {
    return ArticleSingleState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: error ?? this.error,
      article: article ?? this.article,
    );
  }

  factory ArticleSingleState.initial() {
    return ArticleSingleState();
  }
}
