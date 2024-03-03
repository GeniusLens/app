import 'package:genius_lens/api/http.dart';
import 'package:genius_lens/data/entity/result.dart';

import '../../data/entity/generate.dart';

class GenerateApi {
  static const String _prefix = '/generate';

  static Future<List<CategoryVO>> getCategoryList() async {
    var response = await HttpUtil.get('$_prefix/category/list');
    var wrapper = Result.fromJson(response.data);
    List<CategoryVO> list = [];
    for (var item in wrapper.data) {
      list.add(CategoryVO.fromJson(item));
    }
    return list;
  }

  static Future<List<CategoryVO>> getSubCategoryList(String category) async {
    var response = await HttpUtil.get('$_prefix/category/list',
        queryParameters: {'name': category});
    var wrapper = Result.fromJson(response.data);
    List<CategoryVO> list = [];
    for (var item in wrapper.data) {
      list.add(CategoryVO.fromJson(item));
    }
    return list;
  }

  static Future<List<FunctionVO>> getFunctionList(String category) async {
    var response = await HttpUtil.get('$_prefix/function/list',
        queryParameters: {'category': category});
    var wrapper = Result.fromJson(response.data);
    List<FunctionVO> list = [];
    for (var item in wrapper.data) {
      list.add(FunctionVO.fromJson(item));
    }
    return list;
  }

  static Future<FunctionVO> getFunction(int id) async {
    var response = await HttpUtil.get('$_prefix/function/$id');
    var wrapper = Result.fromJson(response.data);
    return FunctionVO.fromJson(wrapper.data);
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

  static Future<List<SampleVO>> getSamples(int functionId) async {
    var response = await HttpUtil.get('$_prefix/function/sample',
        queryParameters: {'id': functionId});
    var wrapper = Result.fromJson(response.data);
    List<SampleVO> list = [];
    for (var item in wrapper.data) {
      list.add(SampleVO.fromJson(item));
    }
    return list;
  }

  static Future<int> submitTask({
    FunctionVO? f,
    List<LoraVO>? lora,
    List<String>? images,
  }) async {
    var response = await HttpUtil.post('$_prefix/inference', data: {
      'function': f?.id,
      'loraIds': lora?.map((e) => "").toList(),
      'sourceImages': images,
    });
    var wrapper = Result.fromJson(response.data);
    return wrapper.data['id'] as int;
  }

  static Future<List<TaskVO>> getTaskList() async {
    var response = await HttpUtil.get('$_prefix/inference/list');
    var wrapper = Result.fromJson(response.data);
    List<TaskVO> list = [];
    for (var item in wrapper.data) {
      list.add(TaskVO.fromJson(item));
    }
    return list;
  }

  static Future<TaskVO> getTaskInfo(int id) async {
    var response = await HttpUtil.get('$_prefix/inference/$id');
    var wrapper = Result.fromJson(response.data);
    return TaskVO.fromJson(wrapper.data);
  }
}
