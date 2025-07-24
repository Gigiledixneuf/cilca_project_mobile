import 'dart:convert';

RegisterUser registerUserFromJson(String str) =>
    RegisterUser.fromJson(json.decode(str));

String registerUserToJson(RegisterUser data) => json.encode(data.toJson());

class RegisterUser {
  String name;
  String email;
  String password;
  String passwordConfirmation;
  String sexe;
  String typeUtilisateur;

  RegisterUser({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.sexe,
    required this.typeUtilisateur,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) => RegisterUser(
    name: json["name"],
    email: json["email"],
    password: json["password"],
    passwordConfirmation: json["password_confirmation"],
    sexe: json["sexe"],
    typeUtilisateur: json["type_utilisateur"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "password_confirmation": passwordConfirmation,
    "sexe": sexe,
    "type_utilisateur": typeUtilisateur,
  };
}
