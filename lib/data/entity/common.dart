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