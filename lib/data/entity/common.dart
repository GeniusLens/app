import 'package:json_annotation/json_annotation.dart';

part 'common.g.dart';

@JsonSerializable()
class MessageVO {
  final int id;
  final String message;
  final String? sender;
  final String? senderAvatar;
  final String time;
  final int type;

  MessageVO({
    required this.id,
    required this.message,
    this.sender,
    this.senderAvatar,
    required this.time,
    required this.type,
  });

  factory MessageVO.fromJson(Map<String, dynamic> json) =>
      _$MessageVOFromJson(json);

  Map<String, dynamic> toJson() => _$MessageVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class ClothVO {
  int? id;
  String? prompt;
  String? url;

  ClothVO({
    this.id,
    this.prompt,
    this.url,
  });

  factory ClothVO.fromJson(Map<String, dynamic> json) =>
      _$ClothVOFromJson(json);

  Map<String, dynamic> toJson() => _$ClothVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class ModelVO {
  int? id;
  String? name;
  String? url;

  ModelVO({
    this.id,
    this.name,
    this.url,
  });

  factory ModelVO.fromJson(Map<String, dynamic> json) =>
      _$ModelVOFromJson(json);

  Map<String, dynamic> toJson() => _$ModelVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class DetectVO {
  int? code;
  bool? frontal;
  String? message;
  String? url;

  DetectVO({
    this.code,
    this.frontal,
    this.message,
    this.url,
  });

  // 是否为正面
  bool get isFrontal => frontal ?? false;
  // 是否合格
  bool get isQualified => code == 1;

  factory DetectVO.fromJson(Map<String, dynamic> json) =>
      _$DetectVOFromJson(json);

  Map<String, dynamic> toJson() => _$DetectVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
