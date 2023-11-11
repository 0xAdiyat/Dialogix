// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunityModelImpl _$$CommunityModelImplFromJson(Map<String, dynamic> json) =>
    _$CommunityModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      banner: json['banner'] as String,
      avatar: json['avatar'] as String,
      members:
          (json['members'] as List<dynamic>).map((e) => e as String).toList(),
      mods: (json['mods'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$CommunityModelImplToJson(
        _$CommunityModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'banner': instance.banner,
      'avatar': instance.avatar,
      'members': instance.members,
      'mods': instance.mods,
    };
