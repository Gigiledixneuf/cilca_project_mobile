import 'package:meta/meta.dart';
import 'dart:convert';

class Authentication {
  final String username;
  final String password;

  Authentication({
    required this.username,
    required this.password,
  });

  factory Authentication.fromRawJson(String str) => Authentication.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Authentication.fromJson(Map<String, dynamic> json) => Authentication(
    username: json["username"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
  };
}

