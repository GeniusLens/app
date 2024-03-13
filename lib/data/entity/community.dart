import 'package:genius_lens/data/entity/generate.dart';
import 'package:json_annotation/json_annotation.dart';

part 'community.g.dart';

@JsonSerializable()
class CommunityVO {
  final int id;
  final String title;
  final String content;
  final List<String> images;
  FunctionVO? function;
  final int? functionId;
  final String time;
  final String? userAvatar;
  final String? username;
  final String likeCount; // 点赞数
  // 卡片高度，用于卡片高度不一致的情况
  // 单位不是高度，而是卡片高度的单元数
  // 范围在 0 ~ 5 之间
  final int? cardHeight;

  // 以下用于客户端操作，不是接口返回的数据
  @JsonKey(includeFromJson: false)
  bool isLike = false;

  CommunityVO({
    required this.id,
    required this.title,
    required this.content,
    required this.images,
    required this.function,
    required this.functionId,
    required this.time,
    required this.userAvatar,
    required this.username,
    required this.likeCount,
    required this.cardHeight,
  });

  factory CommunityVO.fromJson(Map<String, dynamic> json) =>
      _$CommunityVOFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable()
class CommentVO {
  final int? id;
  final String? userName;
  final String? userAvatar;
  final String? content;
  final String? time;
  final int? likeCount;

  CommentVO({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.time,
    required this.likeCount,
  });

  factory CommentVO.fromJson(Map<String, dynamic> json) =>
      _$CommentVOFromJson(json);

  Map<String, dynamic> toJson() => _$CommentVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
