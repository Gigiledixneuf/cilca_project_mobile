
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:odc_mobile_template/business/services/article/articleNetworkService.dart';
import 'package:odc_mobile_template/main.dart';
import 'package:odc_mobile_template/pages/articleSingle/ArticleSingleState.dart';
import 'package:odc_mobile_template/utils/http/HttpRequestException.dart';

class ArticleSingleCtrl extends StateNotifier<ArticleSingleState>{
  ArticleSingleCtrl() : super(ArticleSingleState());
  ArticleNetworkService _articleNetworkService = getIt.get<ArticleNetworkService>();

  Future<void> getArticle(int id)async{
    try{
      state = state.copyWith(
        isLoading: true,
        error: null
      );

      final res = await _articleNetworkService.getArticle(id);
      if(res != null){
        state = state.copyWith(
          article: res ,
          isLoading: false,
          error: null
        );
      }else{
        state = state.copyWith(
          error: "Article non trouvé",
          isLoading: false
        );
      }

    }on HttpRequestException catch(e){
      state = state.copyWith(
        error: '${e.body}',
        isLoading: false,
      );
    }catch (e){
      state = state.copyWith(
        isLoading: false,
        error: '$e',
      );
    }
  }
}


final articleSingleCtrlProvider = StateNotifierProvider<ArticleSingleCtrl, ArticleSingleState>(
      (ref) => ArticleSingleCtrl(),
);