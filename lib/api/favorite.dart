
import 'dart:math';

import 'package:genius_lens/data/entity/favorite.dart';
import 'package:genius_lens/data/exception/api_exception.dart';
import 'package:genius_lens/utils/debug_util.dart';

class FavoriteApi {
  final String _prefix = '/favorite';

  Future<List<FavoriteEntity>> getFavoriteList() async {
    List<FavoriteEntity> list = [];

    var length = Random().nextInt(10) + 1;

    Future.delayed(Duration(milliseconds: Random().nextInt(1000) + 500));
    for (var i = 0; i < length; i++) {
      list.add(FavoriteEntity(
        favoriteId: i.toString(),
        title: 'title $i',
        description: 'description $i',
        coverUrl: DebugUtil.getRandomImageURL(),
      ));
    }

    if (Random().nextBool()) {
      throw ParseDataException('parse data error');
    }

    return list;
  }
}