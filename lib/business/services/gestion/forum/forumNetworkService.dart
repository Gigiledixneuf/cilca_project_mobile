import 'package:odc_mobile_template/business/models/forum/forum.dart';

abstract class ForumNetworkService {
  Future<List<Forum>> getForumList();
}