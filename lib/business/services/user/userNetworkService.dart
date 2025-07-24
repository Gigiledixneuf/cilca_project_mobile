import 'package:odc_mobile_template/business/models/user/registerUser.dart';

import '../../models/user/authentication.dart';
import '../../models/user/user.dart';

abstract class UserNetworkService {
  Future<User?> seConnecter(Authentication authentication);
  Future<User?> register(RegisterUser registerUser);
  Future<User> recupererInfoUtilisateur();
}
