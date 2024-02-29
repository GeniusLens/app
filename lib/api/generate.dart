import 'package:genius_lens/api/http.dart';
import 'package:genius_lens/data/entity/result.dart';

import '../data/entity/generate.dart';

class GenerateApi {
  static const String _prefix = '/generate';

  static Future<List<CategoryVO>> getCategoryList() async {
    print('getCategoryList');
    var response = await HttpUtil.get('$_prefix/category/list');
    var wrapper = Result.fromJson(response.data);
    List<CategoryVO> list = [];
    for (var item in wrapper.data) {
      list.add(CategoryVO.fromJson(item));
    }
    return list;
  }

  static Future<List<CategoryVO>> getSubCategoryList(String category) async {
    var response = await HttpUtil.get('$_prefix/category/list', queryParameters: {'name': category});
    var wrapper = Result.fromJson(response.data);
    List<CategoryVO> list = [];
    for (var item in wrapper.data) {
      list.add(CategoryVO.fromJson(item));
    }
    return list;
  }

  static Future<List<FunctionVO>> getFunctionList(String category) async {
    var response = await HttpUtil.get('$_prefix/function/list', queryParameters: {'category': category});
    var wrapper = Result.fromJson(response.data);
    List<FunctionVO> list = [];
    for (var item in wrapper.data) {
      list.add(FunctionVO.fromJson(item));
    }
    return list;
  }

  static Future<List<FunctionVO>> getRecommendFunction(String type) async {
    var response = await HttpUtil.get('$_prefix/function/recommend');
    var wrapper = Result.fromJson(response.data);
    List<FunctionVO> list = [];
    for (var item in wrapper.data) {
      list.add(FunctionVO.fromJson(item));
    }
    return list;
  }

  static Future<List<LoraVO>> getUserLoraList() async {
    var response = await HttpUtil.get('$_prefix/lora/list');
    var wrapper = Result.fromJson(response.data);
    List<LoraVO> list = [];
    for (var item in wrapper.data) {
      list.add(LoraVO.fromJson(item));
    }
    return list;
  }
}
