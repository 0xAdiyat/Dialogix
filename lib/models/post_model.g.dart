// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      link: json['link'] as String?,
      description: json['description'] as String?,
      communityName: json['communityName'] as String,
      communityProfilePic: json['communityProfilePic'] as String,
      upvotes:
          (json['upvotes'] as List<dynamic>).map((e) => e as String).toList(),
      downvotes:
          (json['downvotes'] as List<dynamic>).map((e) => e as String).toList(),
      commentCount: json['commentCount'] as int,
      username: json['username'] as String,
      uid: json['uid'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      awards:
          (json['awards'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'link': instance.link,
      'description': instance.description,
      'communityName': instance.communityName,
      'communityProfilePic': instance.communityProfilePic,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes,
      'commentCount': instance.commentCount,
      'username': instance.username,
      'uid': instance.uid,
      'type': instance.type,
      'createdAt': instance.createdAt.toIso8601String(),
      'awards': instance.awards,
    };
