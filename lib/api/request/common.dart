import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:genius_lens/data/entity/common.dart';
import 'package:uuid/uuid.dart';

import '../../data/entity/result.dart';
import '../http.dart';

class CommonAPi {
  static const String _baseUrl = "https://upload.thuray.xyz";
  static const String _prefix = "/common";

  static Future<String?> uploadFile(String path) async {
    var uuid = const Uuid();
    // 生成一个HS256(UUID())算法的key
    String key = sha256.convert(uuid.v4().codeUnits).toString();
    var response = await HttpUtil.put("$_baseUrl/$key",
        data: FormData.fromMap({
          "file": await MultipartFile.fromFile(path, filename: "image.jpg"),
        }));
    print(response.data);
    if (response.statusCode != 200) {
      return null;
    } else {
      return response.data;
    }
  }

  static Future<List<MessageVO>> getMessages() async {
    var response = await HttpUtil.get("$_prefix/message");
    var wrapper = Result.fromJson(response.data);
    List<MessageVO> list = [];
    for (var item in wrapper.data) {
      list.add(MessageVO.fromJson(item));
    }
    return list;
  }

  static Future<List<ClothVO>> getClothes() async {
    var response = await HttpUtil.get("$_prefix/cloth");
    var wrapper = Result.fromJson(response.data);
    List<ClothVO> list = [];
    for (var item in wrapper.data) {
      list.add(ClothVO.fromJson(item));
    }
    return list;
  }

  static Future<List<ModelVO>> getModels() async {
    var response = await HttpUtil.get("$_prefix/model");
    var wrapper = Result.fromJson(response.data);
    List<ModelVO> list = [];
    for (var item in wrapper.data) {
      list.add(ModelVO.fromJson(item));
    }
    return list;
  }
}
