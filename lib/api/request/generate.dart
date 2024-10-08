import 'package:flutter/material.dart';
import 'package:genius_lens/api/http.dart';
import 'package:genius_lens/api/state.dart';
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

  static Future<bool> deleteLora(int id) async {
    var response = await HttpUtil.delete('$_prefix/lora/$id');
    var wrapper = Result.fromJson(response.data);
    return wrapper.code == '200';
  }

  static Future<LoraVO?> updateLora({
    int? id,
    String? name,
  }) async {
    var response = await HttpUtil.post('$_prefix/lora/edit', data: {
      'id': id,
      'name': name,
    });
    var wrapper = Result.fromJson(response.data);
    return wrapper.code == '200' ? LoraVO.fromJson(wrapper.data) : null;
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

  /// 提交推理任务
  static Future<int?> submitTask({
    int? type,
    FunctionVO? f,
    List<LoraVO>? lora,
    List<String>? images,
    String? sceneId,
    int? clothId,
  }) async {
    var response = await HttpUtil.post('$_prefix/inference', data: {
      'taskType': type ?? 1,
      'function': f?.id,
      'loraIds': lora?.map((e) => e.id).toList(),
      'sourceImages': images,
      'sceneId': sceneId,
      'clothId': clothId,
    });
    var wrapper = Result.fromJson(response.data);

    return (type != null && type == 2)
        ? (wrapper.code == '200' ? 1 : null)
        : wrapper.data['id'] as int?;
  }

  /// 提交换装任务
  /// [modelUrl] 模特图片地址
  /// [clothUrl] 服装图片地址
  /// [func] 功能
  /// [clothId] 服装ID
  static Future<int?> submitTryonTask({
    required String modelUrl,
    required String clothUrl,
    required FunctionVO func,
    required int clothId,
  }) async {
    List<String> images = [];
    images.add(modelUrl);
    images.add(clothUrl);
    return await GenerateApi.submitTask(
      f: func,
      images: images,
      clothId: clothId,
    );
  }

  static Future<List<TaskVO>> getTaskList(String? category) async {
    var response = await HttpUtil.get('$_prefix/inference/list',
        queryParameters: {'parentCategory': category});
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

  static Future<String> wearEvaluation(String image) async {
    // 构建请求体
    Map<String, dynamic> data = {
      "model": "gpt-4-vision-preview",
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "type": "text",
              "text":
                  "你现在是一个服装设计大师，尤其擅长于研究服装穿搭。我希望你能评价一下我的照片中的穿搭，要求在保证专业性的前提下，语言文字易懂。策略：首先专注于图片中的最显眼的那个人物，分析其总体穿搭表现。根据第一次分析的结果，再次评价，并且给出你的专业建议。返回格式如下，\"{xxx}\"表示占位符：  1. 总体评价  {总体评价结果}  2. 穿搭建议  {专业穿搭建议}  现在请你对我的这张照片的穿搭进行评价并且给出一定的建议，这对我很重要。"
            },
            {
              "type": "image_url",
              "image_url": {"url": image}
            }
          ]
        }
      ],
      "max_tokens": 512
    };
    // print(data);

    // 临时修改Header
    HttpUtil.removeHeader('Authorization');
    HttpUtil.addHeader('Authorization',
        'Bearer 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');

    var response = await HttpUtil.post(
      'https://api.openai.com/v1/chat/completions',
      data: data,
    );

    // 还原Header
    HttpUtil.removeHeader('Authorization');
    HttpUtil.addHeader('Authorization', 'Bearer ${ApiState().tokenValue}');

    // 解析返回结果
    return response.data['choices'][0]['message']['content'];
  }

  static Future<String> getReferenceImage(String prompt) async {
    // 构建请求体
    Map<String, dynamic> data = {
      "model": "dall-e-3",
      "prompt": prompt,
      "n": 1,
      "size": "1024x1024"
    };

    // 临时修改Header
    HttpUtil.removeHeader('Authorization');
    HttpUtil.addHeader('Authorization',
        'Bearer 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');

    var response = await HttpUtil.post(
      'https://api.openai.com/v1/images/generations',
      data: data,
    );

    // 还原Header
    HttpUtil.removeHeader('Authorization');
    HttpUtil.addHeader('Authorization', 'Bearer ${ApiState().tokenValue}');

    // 解析返回结果
    return response.data['data'][0]['url'];
  }
}
