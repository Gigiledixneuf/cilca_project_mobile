
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/pages/communaute/repliesTopic/RepliesTopicState.dart';

import '../../../business/services/communaute/forumNetworkService.dart';
import '../../../main.dart';
import '../../../utils/http/HttpRequestException.dart';

class RepliesTopicCtrl extends StateNotifier<RepliesTopicState>{
  RepliesTopicCtrl(): super(RepliesTopicState.initial());
  ForumNetworkService  _forumNetworkService = getIt.get<ForumNetworkService>();

  Future<void> getRepliesTopic(int id)async{
    try{
      state = state.copyWith(
          isLoading: true,
          error: null
      );
      final res = await _forumNetworkService.getRepliesTopic(id);
      if(res != null){
        state = state.copyWith(
            replies : res,
            isLoading: false,
            error: null
        );
      }else{
        state = state.copyWith(
            isLoading: false,
            error: 'Forum non trouvé'
        );
      }
    }on HttpRequestException catch(e){
      state = state.copyWith(
          isLoading: false,
          error: '${e.body}'
      );
    }catch (e){
      state = state.copyWith(
          isLoading: false,
          error: '$e'
      );
    }
  }
}

final RepliesTopicCtrlProvider = StateNotifierProvider<RepliesTopicCtrl, RepliesTopicState>(
        (ref) => RepliesTopicCtrl()
);