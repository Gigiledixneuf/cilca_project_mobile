
import '../../business/models/article/article.dart';

class HomeState {
  final bool isLoading;
  final String? error;
  final List<Article> featuredArticles;
  final List<Article> latestArticles;

  HomeState({
    required this.isLoading,
    this.error,
    required this.featuredArticles,
    required this.latestArticles,
  });

  factory HomeState.initial() => HomeState(
    isLoading: false,
    featuredArticles: [],
    latestArticles: [],
  );

  HomeState copyWith({
    bool? isLoading,
    String? error,
    List<Article>? featuredArticles,
    List<Article>? latestArticles,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      featuredArticles: featuredArticles ?? this.featuredArticles,
      latestArticles: latestArticles ?? this.latestArticles,
    );
  }
}