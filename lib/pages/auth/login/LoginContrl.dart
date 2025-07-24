
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:odc_mobile_template/business/models/user/authentication.dart';
import 'package:odc_mobile_template/business/services/user/userLocalService.dart';
import 'package:odc_mobile_template/business/services/user/userNetworkService.dart';
import 'package:odc_mobile_template/main.dart';
import 'package:odc_mobile_template/pages/auth/login/LoginState.dart';
import 'package:odc_mobile_template/utils/http/HttpRequestException.dart';
import 'package:path/path.dart';

class LoginCtrl extends StateNotifier<LoginState>{

  final UserNetworkService network = getIt.get<UserNetworkService>();
  final UserLocalService local = getIt.get<UserLocalService>();

  LoginCtrl(): super(LoginState.initial());

  Future<bool> loginUser(Authentication data) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    if (data.username.isEmpty || data.password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Veuillez remplir tous les champs.",
      );
      durationToast();
      return false;
    }

    try {
      final user = await network.seConnecter(data);

      if (user != null) {
        final res = await local.sauvegarderUser(user);

        state = state.copyWith(
          isLoading: false,
          successMessage: "Connexion réussie",
        );
        durationToast();
        return res;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: "Identifiants incorrects.",
        );
        print("Identifiants");
        durationToast();
        return false;
      }

    } on HttpRequestException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "${e.body}",
      );
      print(e.body);
      durationToast();
      return false;
    } on TimeoutException catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Temps d'attente dépassé. Le serveur ne répond pas.",
      );
      print("erreur serveur");
      durationToast();
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "$e",
      );
      print(e);
      durationToast();
      return false;
    }
  }

  Future<void> recupererUserLocal()async{
    final user = await local.recupererUser();
    state =  state.copyWith(user : user);
  }

  // Nettoie les messages d'erreur et de succès (ex. après affichage)
  void resetMessages() {
    state = state.copyWith(
      errorMessage: null,
      successMessage: null,
    );
  }

  durationToast(){
    Future.delayed(Duration(seconds: 3),(){
      resetMessages();
    });
  }

}

// Déclaration du Provider Riverpod pour le LoginCtrl
final LoginCtrlProvider = StateNotifierProvider<LoginCtrl, LoginState>((ref) {
  ref.keepAlive(); // Permet de garder le provider actif en mémoire (utile dans une session de login)
  return LoginCtrl(); // Retourne une instance du contrôleur
});
