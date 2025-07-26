

import 'dart:convert';

import 'package:odc_mobile_template/utils/http/HttpUtils.dart';

import '../../business/models/communaute/forum.dart';
import '../../business/services/communaute/forumNetworkService.dart';
import '../utils/http/localHttpUtils.dart';

class ForumServiceImpl extends ForumNetworkService{

  final String baseUrl;
  final HttpUtils httpUtils;

  ForumServiceImpl({required this.baseUrl, required this.httpUtils});
  @override
  Future<List<Forum>> getForums() async{
    var url = '$baseUrl/wp/v2/forums';

    var response = await httpUtils.getData(url);
    print(response);

    var data = jsonDecode(response);

    // Convertir chaque élément JSON en un objet Forum
    List<Forum> forums = (data as List).map((item) => Forum.fromJson(item)).toList();

    return forums;

  }

}

void main() async{
  var service = ForumServiceImpl(
    baseUrl: "http://10.252.252.29/wordpress_odc/cilca5/wp-json",
    httpUtils: LocalHttpUtils(),
  );

  try {
    var forumsList = await service.getForums();
    for (var list in forumsList) {
      print("Recuperation des forums");
      print("========================");
      print(list.id);
      print(list.title);
      print(list.description);
      print(list.slug);
      print(list.subscriberCount);
      print(list.hardcodedImage);
      print("=======================");
    }
  } catch (e, stack) {
    print('Erreur lors de la récupération des forums : $e');
    print('Stacktrace : $stack');
  }

}