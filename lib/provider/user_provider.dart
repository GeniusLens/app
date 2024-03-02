import 'package:flutter/material.dart';
import 'package:genius_lens/data/ctx/user_context.dart';

import '../data/entity/user.dart';

class UserProvider with ChangeNotifier {
  UserCtx? _ctx;

  UserCtx? get user => _ctx;

  void initCtx(UserVO user, String token) {
    _ctx = UserCtx(userInfo: user, token: token);
    notifyListeners();
  }

  void clearCtx() {
    _ctx = null;
    notifyListeners();
  }

  void updateToken(String token) {
    _ctx?.token = token;
    notifyListeners();
  }

  void updateUserInfo(UserVO user) {
    _ctx?.userInfo = user;
    notifyListeners();
  }
}
