import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserVO {
  final String? uid;
  final String? phone;
  final String? nickname;
  final String? avatar;
  final String? quote;

  UserVO({
    this.uid,
    this.phone,
    this.nickname,
    this.avatar,
    this.quote,
  });

  factory UserVO.fromJson(Map<String, dynamic> json) => _$UserVOFromJson(json);

  Map<String, dynamic> toJson() => _$UserVOToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
