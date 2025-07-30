import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/business/services/article/articleNetworkService.dart';
import 'package:odc_mobile_template/main.dart';
import 'package:odc_mobile_template/utils/http/HttpRequestException.dart';
import 'ArticleState.dart';

class ArticleCtrl extends StateNotifier<ArticleState> {
  ArticleCtrl() : super(ArticleState());

  final ArticleNetworkService _articleNetwork = getIt.get<ArticleNetworkService>();

  Future<void> getArticles() async {
    try {
      state = state.copyWith(
        isLoadingArticles: true,
        selectedCategory: null, // Ajoutez cette ligne
        error: null,
      );

      final res = await _articleNetwork.getArticles();

      if (res != null) {
        state = state.copyWith(
          isLoadingArticles: false,
          articles: res,
          selectedCategory: null, // Et cette ligne aussi
        );
      } else {
        state = state.copyWith(
          isLoadingArticles: false,
          error: "Erreur lors du chargement des articles",
        );
      }
    } on HttpRequestException catch (e) {
      state = state.copyWith(
        isLoadingArticles: false,
        error: "Erreur serveur : ${e.body}",
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingArticles: false,
        error: "Erreur : $e",
      );
    }
  }

  Future<void> getCategories() async {
    try {
      state = state.copyWith(
        isLoadingCategories: true,
        error: null,
      );

      final res = await _articleNetwork.getCategories();

      if (res != null) {
        state = state.copyWith(
          isLoadingCategories: false,
          categories: res,
        );
      } else {
        state = state.copyWith(
          isLoadingCategories: false,
          error: "Erreur lors du chargement des catégories",
        );
      }
    } on HttpRequestException catch (e) {
      state = state.copyWith(
        isLoadingCategories: false,
        error: "Erreur serveur : ${e.body}",
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingCategories: false,
        error: "Erreur : $e",
      );
    }
  }

  Future<void> loadArticlesByCategory(String categoryName) async {
    try {
      state = state.copyWith(
        isLoadingArticles: true,
        selectedCategory: categoryName, // Cette ligne est cruciale
        error: null,
      );

      final res = await _articleNetwork.getArticleByCategory(categoryName);

      if (res != null) {
        state = state.copyWith(
          isLoadingArticles: false,
          articles: res,
          selectedCategory: categoryName, // Et cette ligne aussi
        );
      } else {
        state = state.copyWith(
          isLoadingArticles: false,
          error: "Aucun article trouvé pour cette catégorie.",
        );
      }
    } on HttpRequestException catch (e) {
      state = state.copyWith(
        isLoadingArticles: false,
        error: "Erreur serveur : ${e.body}",
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingArticles: false,
        error: "Erreur : $e",
      );
    }
  }
}

final ArticleCtrlProvider = StateNotifierProvider<ArticleCtrl, ArticleState>(
      (ref) => ArticleCtrl(),
);
