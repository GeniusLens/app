// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModelEntity _$UserModelEntityFromJson(Map<String, dynamic> json) =>
    UserModelEntity(
      modelId: json['modelId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      coverUrl: json['coverUrl'] as String,
      isDemo: json['isDemo'] as bool,
    );

Map<String, dynamic> _$UserModelEntityToJson(UserModelEntity instance) =>
    <String, dynamic>{
      'modelId': instance.modelId,
      'name': instance.name,
      'description': instance.description,
      'coverUrl': instance.coverUrl,
      'isDemo': instance.isDemo,
    };
