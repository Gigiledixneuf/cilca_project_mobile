
import 'dart:convert';

import 'package:flutter/src/foundation/annotations.dart';
import 'package:odc_mobile_template/business/models/article/article.dart';
import 'package:odc_mobile_template/business/services/article/articleNetworkService.dart';
import 'package:odc_mobile_template/framework/utils/http/localHttpUtils.dart';
import 'package:odc_mobile_template/utils/http/HttpRequestException.dart';
import 'package:odc_mobile_template/utils/http/HttpUtils.dart';
import '../../business/models/article/category.dart';

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

    List<Article> article = (data as List).map((item) => Article.fromJson(item, imageUrl: imageUrl)).toList();
    return article;
  }

  @override
  Future<List<Article>> getFeaturedArticles() async {
    // 1. Récupérer les catégories
    final categoriesUrl = '$baseUrl/wp/v2/categories';
    print('Fetching categories: $categoriesUrl');
    final categoriesResponse = await httpUtils.getData(categoriesUrl);
    final categoriesData = jsonDecode(categoriesResponse);

    // 2. Trouver dynamiquement l'ID de la catégorie "actualité" (insensible à la casse)
    int? actualiteCategoryId;
    for (var category in categoriesData) {
      final name = category['name'].toString().toLowerCase();
      if (name == 'actualité' || name == 'actualités') {
        actualiteCategoryId = category['id'];
        break;
      }
    }

    // 3. Si la catégorie n'existe pas, retourner une liste vide
    if (actualiteCategoryId == null) {
      print('Catégorie "actualité" non trouvée');
      return [];
    }

    // 4. Récupérer les articles de cette catégorie
    final postsUrl = '$baseUrl/wp/v2/posts?_embed&per_page=3&categories=$actualiteCategoryId';
    print('Fetching articles from: $postsUrl');

    final postsResponse = await httpUtils.getData(postsUrl);
    final postsData = jsonDecode(postsResponse);

    // 5. Convertir les données JSON en objets Article
    return (postsData as List).map((item) => Article.fromJson(item, imageUrl: imageUrl)).toList();
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
  //recuperer  article detail
  Future<Article> getArticle(int id) async{
    var url = '$baseUrl/wp/v2/posts/$id?_embed';
    var response = await httpUtils.getData(url);
    var data = jsonDecode(response);
    return Article.fromJson(data, imageUrl: imageUrl);
  }

  @override
  Future<List<Article>> getArticleByCategory(String categoryName) async {
    // 1. Récupérer toutes les catégories
    final categoriesUrl = '$baseUrl/wp/v2/categories';
    print('Fetching categories: $categoriesUrl');
    final categoriesResponse = await httpUtils.getData(categoriesUrl);
    final categoriesData = jsonDecode(categoriesResponse);

    // 2. Chercher dynamiquement l'ID de la catégorie (insensible à la casse)
    int? categoryId;
    for (var category in categoriesData) {
      final name = category['name'].toString().toLowerCase();
      if (name == categoryName.toLowerCase()) {
        categoryId = category['id'];
        break;
      }
    }

    // 3. Si la catégorie n'existe pas, retourner une liste vide
    if (categoryId == null) {
      print('Catégorie "$categoryName" non trouvée');
      return [];
    }

    // 4. Récupérer les articles de la catégorie trouvée
    final postsUrl =
        '$baseUrl/wp/v2/posts?_embed&categories=$categoryId';
    print('Fetching articles from: $postsUrl');

    final postsResponse = await httpUtils.getData(postsUrl);
    final postsData = jsonDecode(postsResponse);

    // 5. Convertir les articles JSON en objets Article
    return (postsData as List)
        .map((item) => Article.fromJson(item, imageUrl: imageUrl))
        .toList();
  }

  @override
  Future<List<ArticleCategory>> getCategories() async {
    var url = '$baseUrl/wp/v2/categories';
    var response = await httpUtils.getData(url);
    var data = jsonDecode(response);

    List<ArticleCategory> categories = (data as List)
        .map((item) => ArticleCategory.fromJson(item))
        .toList();

    return categories;
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
      var articlesList = await service.getFeaturedArticles();
        print("Recuperation des articles");
        for(var articleList in articlesList){
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
        }
    }on HttpRequestException catch(e) {
      print("Erreur serveur : ${e.body}");
      print("Erreur serveur : ${e.message}");
    }catch (e, stack) {
      print('Erreur lors de la récupération des forums : $e');
      print('Stacktrace : $stack');
    }
}