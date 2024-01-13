import 'package:json_annotation/json_annotation.dart';

part 'community.g.dart';

@JsonSerializable()
class CommunityRecommendEntity {
  final String recommendId;
  final String title;
  final String userAvatarUrl;
  final String userName;
  final String coverUrl;
  final int likeCount; // 点赞数
  // 卡片高度，用于卡片高度不一致的情况
  // 单位不是高度，而是卡片高度的单元数
  // 范围在 0 ~ 8 之间
  final int cardHeight;

  // 以下用于客户端操作，不是接口返回的数据
  @JsonKey(includeFromJson: true)
  bool isLike = false;

  CommunityRecommendEntity({
    required this.recommendId,
    required this.title,
    required this.userAvatarUrl,
    required this.userName,
    required this.coverUrl,
    required this.likeCount,
    required this.cardHeight,
  });

  factory CommunityRecommendEntity.fromJson(Map<String, dynamic> json) =>
      _$CommunityRecommendEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityRecommendEntityToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}