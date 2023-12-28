// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return _PostModel.fromJson(json);
}

/// @nodoc
mixin _$PostModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get link => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get communityName => throw _privateConstructorUsedError;
  String get communityProfilePic => throw _privateConstructorUsedError;
  List<String> get upvotes => throw _privateConstructorUsedError;
  List<String> get downvotes => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<String> get awards => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PostModelCopyWith<PostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostModelCopyWith<$Res> {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) then) =
      _$PostModelCopyWithImpl<$Res, PostModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String? link,
      String? description,
      String communityName,
      String communityProfilePic,
      List<String> upvotes,
      List<String> downvotes,
      int commentCount,
      String username,
      String uid,
      String type,
      DateTime createdAt,
      List<String> awards});
}

/// @nodoc
class _$PostModelCopyWithImpl<$Res, $Val extends PostModel>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? link = freezed,
    Object? description = freezed,
    Object? communityName = null,
    Object? communityProfilePic = null,
    Object? upvotes = null,
    Object? downvotes = null,
    Object? commentCount = null,
    Object? username = null,
    Object? uid = null,
    Object? type = null,
    Object? createdAt = null,
    Object? awards = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      communityName: null == communityName
          ? _value.communityName
          : communityName // ignore: cast_nullable_to_non_nullable
              as String,
      communityProfilePic: null == communityProfilePic
          ? _value.communityProfilePic
          : communityProfilePic // ignore: cast_nullable_to_non_nullable
              as String,
      upvotes: null == upvotes
          ? _value.upvotes
          : upvotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      downvotes: null == downvotes
          ? _value.downvotes
          : downvotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      awards: null == awards
          ? _value.awards
          : awards // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostModelImplCopyWith<$Res>
    implements $PostModelCopyWith<$Res> {
  factory _$$PostModelImplCopyWith(
          _$PostModelImpl value, $Res Function(_$PostModelImpl) then) =
      __$$PostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? link,
      String? description,
      String communityName,
      String communityProfilePic,
      List<String> upvotes,
      List<String> downvotes,
      int commentCount,
      String username,
      String uid,
      String type,
      DateTime createdAt,
      List<String> awards});
}

/// @nodoc
class __$$PostModelImplCopyWithImpl<$Res>
    extends _$PostModelCopyWithImpl<$Res, _$PostModelImpl>
    implements _$$PostModelImplCopyWith<$Res> {
  __$$PostModelImplCopyWithImpl(
      _$PostModelImpl _value, $Res Function(_$PostModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? link = freezed,
    Object? description = freezed,
    Object? communityName = null,
    Object? communityProfilePic = null,
    Object? upvotes = null,
    Object? downvotes = null,
    Object? commentCount = null,
    Object? username = null,
    Object? uid = null,
    Object? type = null,
    Object? createdAt = null,
    Object? awards = null,
  }) {
    return _then(_$PostModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      communityName: null == communityName
          ? _value.communityName
          : communityName // ignore: cast_nullable_to_non_nullable
              as String,
      communityProfilePic: null == communityProfilePic
          ? _value.communityProfilePic
          : communityProfilePic // ignore: cast_nullable_to_non_nullable
              as String,
      upvotes: null == upvotes
          ? _value._upvotes
          : upvotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      downvotes: null == downvotes
          ? _value._downvotes
          : downvotes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      awards: null == awards
          ? _value._awards
          : awards // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostModelImpl extends _PostModel {
  _$PostModelImpl(
      {required this.id,
      required this.title,
      this.link,
      this.description,
      required this.communityName,
      required this.communityProfilePic,
      required final List<String> upvotes,
      required final List<String> downvotes,
      required this.commentCount,
      required this.username,
      required this.uid,
      required this.type,
      required this.createdAt,
      required final List<String> awards})
      : _upvotes = upvotes,
        _downvotes = downvotes,
        _awards = awards,
        super._();

  factory _$PostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? link;
  @override
  final String? description;
  @override
  final String communityName;
  @override
  final String communityProfilePic;
  final List<String> _upvotes;
  @override
  List<String> get upvotes {
    if (_upvotes is EqualUnmodifiableListView) return _upvotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upvotes);
  }

  final List<String> _downvotes;
  @override
  List<String> get downvotes {
    if (_downvotes is EqualUnmodifiableListView) return _downvotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_downvotes);
  }

  @override
  final int commentCount;
  @override
  final String username;
  @override
  final String uid;
  @override
  final String type;
  @override
  final DateTime createdAt;
  final List<String> _awards;
  @override
  List<String> get awards {
    if (_awards is EqualUnmodifiableListView) return _awards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_awards);
  }

  @override
  String toString() {
    return 'PostModel(id: $id, title: $title, link: $link, description: $description, communityName: $communityName, communityProfilePic: $communityProfilePic, upvotes: $upvotes, downvotes: $downvotes, commentCount: $commentCount, username: $username, uid: $uid, type: $type, createdAt: $createdAt, awards: $awards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.communityName, communityName) ||
                other.communityName == communityName) &&
            (identical(other.communityProfilePic, communityProfilePic) ||
                other.communityProfilePic == communityProfilePic) &&
            const DeepCollectionEquality().equals(other._upvotes, _upvotes) &&
            const DeepCollectionEquality()
                .equals(other._downvotes, _downvotes) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._awards, _awards));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      link,
      description,
      communityName,
      communityProfilePic,
      const DeepCollectionEquality().hash(_upvotes),
      const DeepCollectionEquality().hash(_downvotes),
      commentCount,
      username,
      uid,
      type,
      createdAt,
      const DeepCollectionEquality().hash(_awards));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      __$$PostModelImplCopyWithImpl<_$PostModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostModelImplToJson(
      this,
    );
  }
}

abstract class _PostModel extends PostModel {
  factory _PostModel(
      {required final String id,
      required final String title,
      final String? link,
      final String? description,
      required final String communityName,
      required final String communityProfilePic,
      required final List<String> upvotes,
      required final List<String> downvotes,
      required final int commentCount,
      required final String username,
      required final String uid,
      required final String type,
      required final DateTime createdAt,
      required final List<String> awards}) = _$PostModelImpl;
  _PostModel._() : super._();

  factory _PostModel.fromJson(Map<String, dynamic> json) =
      _$PostModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get link;
  @override
  String? get description;
  @override
  String get communityName;
  @override
  String get communityProfilePic;
  @override
  List<String> get upvotes;
  @override
  List<String> get downvotes;
  @override
  int get commentCount;
  @override
  String get username;
  @override
  String get uid;
  @override
  String get type;
  @override
  DateTime get createdAt;
  @override
  List<String> get awards;
  @override
  @JsonKey(ignore: true)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
