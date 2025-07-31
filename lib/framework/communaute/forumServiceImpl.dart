

import 'dart:convert';

import 'package:odc_mobile_template/business/models/communaute/reply.dart';
import 'package:odc_mobile_template/business/models/communaute/topic.dart';
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

  @override
  Future<List<Topic>> getTopicsForum(int id) async{
    var url = '$baseUrl/wp/v2/forums/$id/topics';
    var response = await httpUtils.getData(url);
    var data = jsonDecode(response);

    List<Topic> topics = (data as List).map((item)=> Topic.fromJson(item)).toList();
    return topics;
  }

  @override
  Future<List<Reply>> getRepliesTopic(int id) async {
    var url = '$baseUrl/wp/v2/topics/$id/replies';
    var response = await httpUtils.getData(url);
    var data = jsonDecode(response);
    List<Reply> replies = (data as List).map((item)=> Reply.fromJson(item)).toList();
    return replies;
  }

}

void main() async{
  var service = ForumServiceImpl(
    baseUrl: "http://172.20.10.2/wordpress_odc/cilca5/wp-json",
    httpUtils: LocalHttpUtils(),
  );

  try {
    var topics = await service.getRepliesTopic(1396);
    for (var list in topics) {
      print("Recuperation comments du sujet");
      print("========================");
      print(list.id);
      print(list.content);
      print(list.author);
      print(list.link);
      print(list.date);
      print("=======================");
    }
  } catch (e, stack) {
    print('Erreur lors de la récupération sujets des forums : $e');
    print('Stacktrace : $stack');
  }

}