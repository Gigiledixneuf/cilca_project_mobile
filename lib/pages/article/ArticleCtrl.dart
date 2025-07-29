
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/business/services/article/articleNetworkService.dart';
import 'package:odc_mobile_template/main.dart';
import 'package:odc_mobile_template/utils/http/HttpRequestException.dart';

import 'ArticleState.dart';

class ArticleCtrl extends StateNotifier<ArticleState>{
  ArticleCtrl(): super(ArticleState.initial());

  ArticleNetworkService _articleNetwork = getIt.get<ArticleNetworkService>();

  Future<void> getArticles()async{
    try{
      state = state.copyWith(
          isLoading: true,
          error: null
      );

      final res = await _articleNetwork.getArticles();

      if(res != null){
        state = state.copyWith(
          isLoading: false,
          articles: res
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

final ArticleCtrlProvider = StateNotifierProvider<ArticleCtrl, ArticleState>(
        (ref) => ArticleCtrl()
);