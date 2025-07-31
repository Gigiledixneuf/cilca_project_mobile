
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odc_mobile_template/business/services/communaute/forumNetworkService.dart';
import 'package:odc_mobile_template/main.dart';
import 'package:odc_mobile_template/pages/communaute/topicsForum/TopicsForumState.dart';
import 'package:odc_mobile_template/utils/http/HttpRequestException.dart';

class TopicsForumCtrl extends StateNotifier<TopicsForumState>{
  TopicsForumCtrl(): super(TopicsForumState.initial());
  ForumNetworkService _forumNetworkService = getIt.get<ForumNetworkService>();

  Future<void> getTopicsForum(int id)async{
    try{
      state = state.copyWith(
        isLoading: true,
        error: null
      );
      final res = await _forumNetworkService.getTopicsForum(id);
      if(res != null){
        state = state.copyWith(
          topics: res,
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

final TopicsForumCtrlProvider = StateNotifierProvider<TopicsForumCtrl, TopicsForumState>(
        (ref) => TopicsForumCtrl()
);