import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// 本文件用于定义用户模型（AI分身）的相关数据结构

/// 用户模型（AI分身）的数据结构
@JsonSerializable()
class UserModelEntity {
  final String modelId;
  final String name;
  final String description;
  final String coverUrl;
  final bool isDemo;

  UserModelEntity({
    required this.modelId,
    required this.name,
    required this.description,
    required this.coverUrl,
    required this.isDemo,
  });

  factory UserModelEntity.fromJson(Map<String, dynamic> json) =>
      _$UserModelEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelEntityToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
