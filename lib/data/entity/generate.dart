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

  FunctionVO(this.id, this.name, this.description, this.url, this.type);

  factory FunctionVO.fromJson(Map<String, dynamic> json) =>
      _$FunctionVOFromJson(json);

  Map<String, dynamic> toJson() => _$FunctionVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class LoraVO {
  final String? name;
  final String? description;

  // final List<String>? images;
  final String avatar;
  final bool? defaultFlag;
  final int status;

  LoraVO(
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
