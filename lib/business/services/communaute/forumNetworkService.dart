
import 'package:odc_mobile_template/business/models/communaute/forum.dart';

abstract class ForumNetworkService {
  Future<List<Forum>> getForums();
}