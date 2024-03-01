
import 'package:genius_lens/data/entity/result.dart';

import '../data/entity/user.dart';
import 'http.dart';

class UserApi {
  static const String _prefix = '/user';

  static Future<UserVO> getUserInfo() async {
    var response = await HttpUtil.get('$_prefix/info');
    var wrapper = Result.fromJson(response.data);
    return UserVO.fromJson(wrapper.data);
  }
}