import 'package:json_annotation/json_annotation.dart';

part 'generate.g.dart';

@JsonSerializable()
class CategoryVO {
  final String name;
  final String? description;
  final String? cover;

  CategoryVO(this.name, this.description, this.cover);

  factory CategoryVO.fromJson(Map<String, dynamic> json) =>
      _$CategoryVOFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class FunctionVO {
  final int id;
  final String? name;
  final String? description;
  final String? url;
  final String type;
  final int? peopleCount;

  FunctionVO(this.id, this.name, this.description, this.url, this.type,
      this.peopleCount);

  // 自定义构造函数
  FunctionVO.custom(url) : this(85, '自定义', '', url, '', 0);

  factory FunctionVO.fromJson(Map<String, dynamic> json) =>
      _$FunctionVOFromJson(json);

  Map<String, dynamic> toJson() => _$FunctionVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

  // copyWith
  FunctionVO copyWith({
    int? id,
    String? name,
    String? description,
    String? url,
    String? type,
    int? peopleCount,
  }) {
    return FunctionVO(
      id ?? this.id,
      name ?? this.name,
      description ?? this.description,
      url ?? this.url,
      type ?? this.type,
      peopleCount ?? this.peopleCount,
    );
  }
}

@JsonSerializable()
class LoraVO {
  final int id;
  final String? name;
  final String? description;

  // final List<String>? images;
  final String avatar;
  final bool? defaultFlag;
  final int status;

  LoraVO(
    this.id,
    this.name,
    this.description,
    this.avatar,
    this.defaultFlag,
    this.status,
  );

  factory LoraVO.fromJson(Map<String, dynamic> json) => _$LoraVOFromJson(json);

  Map<String, dynamic> toJson() => _$LoraVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class SampleVO {
  final String name;
  final int type;
  final String url;

  SampleVO(this.name, this.type, this.url);

  factory SampleVO.fromJson(Map<String, dynamic> json) =>
      _$SampleVOFromJson(json);

  Map<String, dynamic> toJson() => _$SampleVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class TaskVO {
  final int id;
  final String taskId;
  final String? result;
  final String? status;
  final int? statusCode;
  final String function;
  final String time;

  TaskVO(
    this.id,
    this.taskId,
    this.result,
    this.status,
    this.statusCode,
    this.function,
    this.time,
  );

  factory TaskVO.fromJson(Map<String, dynamic> json) => _$TaskVOFromJson(json);

  Map<String, dynamic> toJson() => _$TaskVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

  // copyWith
  TaskVO copyWith({
    int? id,
    String? taskId,
    String? result,
    String? status,
    int? statusCode,
    String? function,
    String? time,
  }) {
    return TaskVO(
      id ?? this.id,
      taskId ?? this.taskId,
      result ?? this.result,
      status ?? this.status,
      statusCode ?? this.statusCode,
      function ?? this.function,
      time ?? this.time,
    );
  }
}
