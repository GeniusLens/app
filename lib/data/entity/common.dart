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
