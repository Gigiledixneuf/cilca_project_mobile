
import 'dart:convert';

import 'package:odc_mobile_template/business/models/user/registerUser.dart';
import 'package:odc_mobile_template/framework/utils/http/localHttpUtils.dart';
import 'package:odc_mobile_template/utils/http/HttpRequestException.dart';

import '../../business/models/user/authentication.dart';

import '../../business/models/user/user.dart';

import '../../business/services/user/userNetworkService.dart';
import '../../utils/http/HttpUtils.dart';

class UserNetworkServiceImpl extends UserNetworkService {
  final String baseUrl;
  final HttpUtils httpUtils;

  UserNetworkServiceImpl({required this.baseUrl, required this.httpUtils});

  @override
  Future<User> recupererInfoUtilisateur() {
    // TODO: implement recupererInfoUtilisateur
    throw UnimplementedError();
  }

  @override
  Future<User?> seConnecter(Authentication authentication) async{
    var url = '$baseUrl/jwt-auth/v1/token';
    print(url);
    var body = authentication.toJson();
    print(body);
    var response = await httpUtils.postData(url, body : body,);
    print('response : $response');
    var decoded = jsonDecode(response);
    var user = User.fromJson(decoded);
    return user ;
  }

  @override
  Future<User?> register(RegisterUser registerUser) async {
    var url =  '$baseUrl/jwt-custom-auth/v1/register';
    print('url de la methode $url');

    var body = registerUser.toJson();
    print('corps de la requette $body');

    var response = await httpUtils.postData(url, body : body);
    print('response $response');

    var decoded = jsonDecode(response);
    var user = User.fromJson(decoded);

    return user;
  }
  
}

//test login
void main() async{
  var service = UserNetworkServiceImpl(
    baseUrl: "http://172.20.10.2/wordpress_odc/cilca5/wp-json",
    httpUtils: LocalHttpUtils(),
  );
  
  try{
    var user = Authentication(username: "admin19", password: "password");
    var test = await service.seConnecter(user);
    print('User envoyé: $user');
    print('user : $test');
  }on HttpRequestException catch(e){
    print('erreur : ${e.body}');
    print("erreur: ${e.message}");
  }catch(e, s){
    print(e.runtimeType);
    print('Erreur : $e');
    print('Erreur : $s');
  }
}