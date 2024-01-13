
import 'dart:math';

import 'package:genius_lens/data/exception/api_exception.dart';
import 'package:genius_lens/data/entity/user_model.dart';

class UserModelApi {
  final String _prefix = '/user_model';

  Future<List<UserModelEntity>> getModels() async {
    List<UserModelEntity> models = [];

    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));

    var length = Random().nextInt(5) + 1;
    var demoIndex = Random().nextInt(length);
    for (int i = 0; i < length; i++) {
      models.add(UserModelEntity(
        modelId: i.toString(),
        name: 'AI分身$i',
        description: '这是一个AI分身的描述',
        coverUrl: 'https://picsum.photos/seed/$i/200/600',
        isDemo: i == demoIndex,
      ));
    }
    // 重新排序，将演示模型放在第一个
    models.sort((a, b) => a.isDemo ? -1 : 1);

    // 模拟处理失败抛出异常
    if (Random().nextBool()) {
      throw ParseDataException('解析数据失败');
    }

    return models;
  }
}