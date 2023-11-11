import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel implements _$UserModel {
  UserModel._();
  factory UserModel(
      {required String name,
      required String profilePic,
      required String banner,
      required String uid,
      required bool isAuthenticated, // If guest or not
      required int karma,
      required List<String> awards}) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toMap() => toJson(); // Use _$UserModelToJson(this)
}
