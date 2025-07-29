import 'package:odc_mobile_template/business/models/article/article.dart';

abstract class ArticleNetworkService{
  //recuperer les articles
  Future<List<Article>> getArticles();
  //recuperer les articles du slider ( actu )
  Future<List<Article>> getFeaturedArticles();
  //recuperer les dernieres articles 5
  Future<List<Article>> getLatestArticles();
  //recuperer un article
  Future<Article> getArticle(int id);
}