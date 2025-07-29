
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/business/services/article/articleNetworkService.dart';

import '../../business/services/gestion/gestionNetworkService.dart';
import '../../main.dart';
import '../../utils/http/HttpRequestException.dart';
import 'homeState.dart';

class HomeCtrl  extends StateNotifier<HomeState>{
  ArticleNetworkService _articleNetworkService = getIt.get<ArticleNetworkService>();

  HomeCtrl() : super(HomeState.initial());

  //recuperer les articles d'actualités à afficher au slide (3)
  Future<void> getFeaturedArticles()async{
    try{
      state = state.copyWith(
          isLoading: true,
          error: null
      );


      final res = await _articleNetworkService.getFeaturedArticles();

      if(res != null){
        state = state.copyWith(
            isLoading: false,
            featuredArticles : res
        );
      }else{
        state = state.copyWith(
            isLoading: false,
            error: "Erreur lors du chargement des articles"
        );
      }
    }on HttpRequestException catch(e){
      state = state.copyWith(
          isLoading: false,
          error: "Erreur serveur : ${e.body}"
      );
    }catch(e){
      state = state.copyWith(
          isLoading: false,
          error: "Erreur : $e"
      );
    }

  }
  //recuperer les derniers articles (5)
  Future<void> getLatestArticles()async{
    try{
      state = state.copyWith(
          isLoading: true,
          error: null
      );

      final res = await _articleNetworkService.getLatestArticles();

      if(res != null){
        state = state.copyWith(
            isLoading: false,
            latestArticles : res
        );
      }else{
        state = state.copyWith(
            isLoading: false,
            error: "Erreur lors du chargement des articles"
        );
      }
    }on HttpRequestException catch(e){
      state = state.copyWith(
          isLoading: false,
          error: "Erreur serveur : ${e.body}"
      );
    }catch(e){
      state = state.copyWith(
          isLoading: false,
          error: "Erreur : $e"
      );
    }

  }

}


final HomeCtrlProvider = StateNotifierProvider<HomeCtrl, HomeState>((ref) => HomeCtrl());
