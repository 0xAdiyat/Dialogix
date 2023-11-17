import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel implements _$UserModel {
  UserModel._();
  factory UserModel({
    required String name,
    required String profilePic,
    required String banner,
    required String uid,
    required bool isAuthenticated,
    required int karma,
    required List<String> awards,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // factory UserModel.fromMap(Map<String, dynamic> map) {
  //   return UserModel(
  //     name: map['name'] as String,
  //     profilePic: map['profilePic'] as String,
  //     banner: map['banner'] as String,
  //     uid: map['uid'] as String,
  //     isAuthenticated: map['isAuthenticated'] as bool,
  //     karma: map['karma'] as int,
  //     awards: (map['awards'] as List<dynamic>).cast<String>(),
  //   );
  // }

  // Map<String, dynamic> toMap() => toJson();
}
