
import 'dart:math';

import 'package:genius_lens/data/entity/profile.dart';

class ProfileApi {
  Future<UserVO> getProfile() async {
    UserVO profile;

    Future.delayed(Duration(milliseconds: Random().nextInt(1000) + 200));
    profile = UserVO(
      nickname: 'nickname',
      avatarUrl: 'https://picsum.photos/200/300',
      signature: Random().nextBool() ? 'signature' : null,
      postCount: Random().nextInt(1000),
      followCount: Random().nextInt(1000),
      fansCount: Random().nextInt(1000),
    );

    return profile;
  }
}