import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
abstract class CommentModel implements _$CommentModel {
  CommentModel._();

  factory CommentModel(
      {required String id,
      required String text,
      required DateTime createdAt,
      required String postId,
      required String username,
      required String profilePic}) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}
