import 'package:genius_lens/data/entity/user.dart';

class UserCtx {
  String? token;
  UserVO? userInfo;

  UserCtx({this.token, this.userInfo});

  @override
  String toString() {
    return 'UserCtx{token: $token, userInfo: $userInfo}';
  }
}