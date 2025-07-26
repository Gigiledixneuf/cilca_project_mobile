

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/business/models/communaute/forum.dart';
import 'package:odc_mobile_template/business/services/communaute/forumNetworkService.dart';
import 'package:odc_mobile_template/framework/communaute/forumServiceImpl.dart';
import 'package:odc_mobile_template/main.dart';
import 'package:odc_mobile_template/utils/http/HttpRequestException.dart';

import 'ForumState.dart';

class ForumCtrl extends StateNotifier<ForumState>{
  ForumCtrl(): super(ForumState.initial());
  ForumNetworkService  _forumNetwork = getIt.get<ForumNetworkService>();

  Future<void> getForums()async{
    try{
      state = state.copyWith(
        isLoading: true,
        error: null
      );
      final res = await _forumNetwork.getForums();

      if(res != null ){
        state = state.copyWith(
          forums: res,
          isLoading: false
        );
      }else{
        state = state.copyWith(
          isLoading: false,
          error: "Aucune donnée recue du serveur..."
        );
      }
    }on HttpRequestException catch(e){
      state = state.copyWith(
        isLoading: false,
        error: '${e.body}',
      );
    }catch (e){
      state = state.copyWith(
        isLoading: false,
        error: 'Erreur lors du chargement initial : ${e.toString()}'
      );
    }

  }
}

final ForumCtrlProvider = StateNotifierProvider<ForumCtrl, ForumState>(
   (ref) => ForumCtrl()
);