import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_model.freezed.dart';
part 'community_model.g.dart';

@freezed
abstract class CommunityModel implements _$CommunityModel {
  CommunityModel._();

  factory CommunityModel(
      {required String id,
      required String name,
      required String banner,
      required String avatar,
      required List<String> members,
      required List<String> mods}) = _CommunityModel;

  factory CommunityModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityModelFromJson(json);

  // factory CommunityModel.fromMap(Map<String, dynamic> map) {
  //   return CommunityModel(
  //     id: map['id'] as String,
  //     name: map['name'] as String,
  //     banner: map['banner'] as String,
  //     avatar: map['avatar'] as String,
  //     members: (map['members'] as List<dynamic>).cast<String>(),
  //     mods: (map['mods'] as List<dynamic>).cast<String>(),
  //   );
  // }

  // Map<String, dynamic> toMap() => toJson();
}
