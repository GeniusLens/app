import 'package:genius_lens/api/state.dart';
import 'package:genius_lens/data/entity/result.dart';
import 'package:genius_lens/data/exception/api_exception.dart';
import 'package:genius_lens/utils/shared_preference_util.dart';

import '../../data/entity/user.dart';
import '../http.dart';

class UserApi {
  static const String _prefix = '/user';

  static Future<UserVO> getUserInfo() async {
    var response = await HttpUtil.get('$_prefix/info');
    var wrapper = Result.fromJson(response.data);
    return UserVO.fromJson(wrapper.data);
  }

  static Future<UserVO> login() async {
    var response = await HttpUtil.post('$_prefix/login', data: {
      'nickname': 'DEMO',
      'phone': '18617635093',
      'password': r"AxfLy(nTi\d[3Z%",
    });
    var wrapper = Result.fromJson(response.data);
    if (wrapper.code == '500') {
      throw WrongPasswordException(wrapper.msg);
    }
    String token = wrapper.data['token'];
    // 将token保存到本地
    await SharedPreferenceUtil().saveData('token', token);
    // 检查是否保存成功
    if (await SharedPreferenceUtil().getData('token') != token) {
      // print('Token save failed');
    }
    ApiState().updateToken(token);
    UserVO user = UserVO.fromJson(wrapper.data['user']);
    return user;
  }
}
