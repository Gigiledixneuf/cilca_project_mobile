import 'package:flutter/foundation.dart';
import 'package:odc_mobile_template/business/models/article/article.dart';

import '../../models/article/category.dart';

abstract class ArticleNetworkService{
  //recuperer les articles
  Future<List<Article>> getArticles();
  //recuperer les articles du slider ( actu )
  Future<List<Article>> getFeaturedArticles();
  //recuperer les dernieres articles 5
  Future<List<Article>> getLatestArticles();
  //ecuperer les categories
  Future<List<ArticleCategory>> getCategories();
  //recuperer article Par categorie
  Future<List<Article>> getArticleByCategory(String categoryName);
  //recuperation detail article
  Future<Article> getArticle(int id);
}