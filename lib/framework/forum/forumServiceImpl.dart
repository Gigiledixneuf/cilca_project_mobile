
import 'dart:convert';

import 'package:odc_mobile_template/business/models/forum/forum.dart';
import 'package:odc_mobile_template/business/services/gestion/forum/forumNetworkService.dart';
import 'package:odc_mobile_template/framework/utils/http/localHttpUtils.dart';
import 'package:odc_mobile_template/utils/http/HttpRequestException.dart';
import 'package:odc_mobile_template/utils/http/HttpUtils.dart';

class ForumServiceImpl extends ForumNetworkService{

  final String baseUrl;
  final HttpUtils httpUtils;

  ForumServiceImpl({required this.baseUrl, required this.httpUtils});
  @override
  Future<List<Forum>> getForumList() async{
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
    baseUrl: "http://172.20.10.2/wordpress_odc/cilca5/wp-json",
    httpUtils: LocalHttpUtils(),
  );

  try {
    var forumsList = await service.getForumList();
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