import 'package:odc_mobile_template/business/models/article/article.dart';

abstract class ArticleNetworkService{
  Future<List<Article>> getArticles();
}