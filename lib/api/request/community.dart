import 'package:flutter/material.dart';
import 'package:genius_lens/api/http.dart';
import 'package:genius_lens/data/entity/community.dart';
import 'package:genius_lens/data/entity/result.dart';

class CommunityApi {
  final String _prefix = '/community';

  Future<List<CommunityVO>> getCommunityRecommendList() async {
    List<CommunityVO> list = [];

    var response = await HttpUtil.get('$_prefix/post/list');
    var wrapper = Result.fromJson(response.data);
    debugPrint(wrapper.data.toString());
    for (var item in wrapper.data) {
      list.add(CommunityVO.fromJson(item));
    }

    return list;
  }
}
