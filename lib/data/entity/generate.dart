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

  LoraVO(
      this.name, this.description, this.avatar, this.defaultFlag);

  factory LoraVO.fromJson(Map<String, dynamic> json) => _$LoraVOFromJson(json);

  Map<String, dynamic> toJson() => _$LoraVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
