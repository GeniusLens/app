import 'package:json_annotation/json_annotation.dart';

part 'favorite.g.dart';

@JsonSerializable()
class FavoriteEntity {
  final String favoriteId;
  final String title;
  final String? description;
  final String coverUrl;

  FavoriteEntity({
    required this.favoriteId,
    required this.title,
    this.description,
    required this.coverUrl,
  });

  factory FavoriteEntity.fromJson(Map<String, dynamic> json) =>
      _$FavoriteEntityFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteEntityToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}