import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class ProfileEntity {
  final String nickname;
  final String avatarUrl;
  final String? signature;

  final int postCount;
  final int followCount;
  final int fansCount;

  ProfileEntity({
    required this.nickname,
    required this.avatarUrl,
    this.signature,
    required this.postCount,
    required this.followCount,
    required this.fansCount,
  });

  factory ProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$ProfileEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileEntityToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}