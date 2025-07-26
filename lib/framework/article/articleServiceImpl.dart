
import 'dart:convert';

import 'package:odc_mobile_template/business/models/article/article.dart';
import 'package:odc_mobile_template/business/services/article/articleNetworkService.dart';
import 'package:odc_mobile_template/framework/utils/http/localHttpUtils.dart';
import 'package:odc_mobile_template/utils/http/HttpUtils.dart';

class ArticleServiceImpl extends ArticleNetworkService {
  final String baseUrl;
  final HttpUtils httpUtils;
  final String imageUrl;

  // Version corrigée du constructeur
  ArticleServiceImpl({
    required this.imageUrl,
    required this.baseUrl,
    required this.httpUtils,
  });

  @override
  Future<List<Article>> getArticles() async {
    var url = '$baseUrl/wp/v2/posts?_embed';
    print('url $url');
    var response = await httpUtils.getData(url);
    print('reponse recu : $response');

    var data = jsonDecode(response);
    print('data recup : $data');

    List<Article> article = (data as List).map((item) =>
        Article.fromJson(item, imageUrl: imageUrl)
    ).toList();
    return article;
  }
}

//Test de recuperation articles

void main() async{
    var service = ArticleServiceImpl(
      baseUrl: "http://10.252.252.51/wordpress_odc/cilca5/wp-json",
      imageUrl : "http://10.252.252.51/",
      httpUtils: LocalHttpUtils(),
    );

    try {
      var articleList = await service.getArticles();
      for (var list in articleList) {
        print("Recuperation des articles");
        print("========================");
        print(list.id);
        print(list.title);
        print(list.category);
        print(list.desc);
        print(list.date);
        print("=======================");
      }
    } catch (e, stack) {
      print('Erreur lors de la récupération des forums : $e');
      print('Stacktrace : $stack');
    }
}