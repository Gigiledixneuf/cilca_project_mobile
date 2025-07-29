
import 'dart:convert';

import 'package:odc_mobile_template/business/models/article/article.dart';
import 'package:odc_mobile_template/business/services/article/articleNetworkService.dart';
import 'package:odc_mobile_template/framework/utils/http/localHttpUtils.dart';
import 'package:odc_mobile_template/utils/http/HttpRequestException.dart';
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

  //recuperer tout les articles
  @override
  Future<List<Article>> getArticles() async {
    var url = '$baseUrl/wp/v2/posts?_embed';
    print('url $url');
    var response = await httpUtils.getData(url);

    var data = jsonDecode(response);

    List<Article> article = (data as List).map((item) =>
        Article.fromJson(item, imageUrl: imageUrl)
    ).toList();
    return article;
  }

  @override
  //recuperer les articles d'actu
  Future<List<Article>> getFeaturedArticles() async{
    var url = '$baseUrl/wp/v2/posts?_embed&per_page=3';
    print('url : $url');
    var response = await httpUtils.getData(url);
    var data = jsonDecode(response);

    List<Article> article = (data as List).map((item)=> Article.fromJson(item, imageUrl: imageUrl)).toList();
    return article;
  }

  @override
  //recuperer les dernieres articles
  Future<List<Article>> getLatestArticles() async{
    var url = '$baseUrl/wp/v2/posts?_embed&per_page=5';
    print('url : $url');
    var response = await httpUtils.getData(url);

    var data = jsonDecode(response);

    List<Article> article = (data as List).map((item)=> Article.fromJson(item, imageUrl: imageUrl)).toList();
    return article;
  }

  @override
  Future<Article> getArticle(int id) async{
    var url = '$baseUrl/wp/v2/posts/$id?_embed';

    var response = await httpUtils.getData(url);
    var data = jsonDecode(response);
    print(data);
    return Article.fromJson(data, imageUrl: imageUrl);
  }
}

//Test de recuperation articles
void main() async{
    var service = ArticleServiceImpl(
      baseUrl: "http://172.20.10.2/wordpress_odc/cilca5/wp-json",
      imageUrl : "http://172.20.10.2",
      httpUtils: LocalHttpUtils(),
    );

    try {
      var articleList = await service.getArticle(1314);
        print("Recuperation des articles");
        print("=========== Debut =============");
        print('id : ');
        print(articleList.id);
        print('titre :');
        print(articleList.title);
        print('categorie :');
        print(articleList.category);
        print('desc :');
        print(articleList.desc);
        print('date: ');
        print(articleList.date);
        print("lien de l'image");
        print(articleList.image);
        print("content");
        print(articleList.content);
        print("author");
        print(articleList.author);
        print("link");
        print(articleList.link);
        print("========= Fin ================");

    }on HttpRequestException catch(e) {
      print("Erreur serveur : ${e.body}");
      print("Erreur serveur : ${e.message}");
    }catch (e, stack) {
      print('Erreur lors de la récupération des forums : $e');
      print('Stacktrace : $stack');
    }
}