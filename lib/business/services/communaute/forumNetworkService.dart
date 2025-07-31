
import 'package:odc_mobile_template/business/models/communaute/forum.dart';
import 'package:odc_mobile_template/business/models/communaute/topic.dart';

import '../../models/communaute/reply.dart';

abstract class ForumNetworkService {
  Future<List<Forum>> getForums();
  Future<List<Topic>> getTopicsForum(int id);
  Future<List<Reply>> getRepliesTopic(int id);
}