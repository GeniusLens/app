import 'dart:math';

import 'package:genius_lens/data/entity/community.dart';
import 'package:genius_lens/utils/debug_util.dart';

class CommunityApi {
  // final String _prefix = '/community';

  Future<List<CommunityRecommendEntity>> getCommunityRecommendList() async {
    List<CommunityRecommendEntity> list = [];

    Future.delayed(Duration(milliseconds: Random().nextInt(1000) + 200));
    for (int i = 0; i < 10; i++) {
      list.add(
        CommunityRecommendEntity(
          recommendId: i.toString(),
          title: 'title',
          userAvatarUrl: 'https://picsum.photos/200/300',
          userName: 'userName',
          coverUrl: DebugUtil.getRandomImageURL(),
          likeCount: Random().nextInt(1000),
          cardHeight: Random().nextInt(8),
        ),
      );
    }

    return list;
  }
}
