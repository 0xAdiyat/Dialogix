import 'dart:io';
import 'dart:typed_data';

import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/post/repository/post_repository.dart';
import 'package:dialogix/models/comment_model.dart';
import 'package:dialogix/models/community_model.dart';
import 'package:dialogix/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>(
    (ref) => PostController(
        postRepository: ref.read(postRepositoryProvider),
        ref: ref,
        storageRepository: ref.read(storageRepositoryProvider)));
final getPostByIdProvider = StreamProvider.family<PostModel, String>(
    (ref, postId) =>
        ref.read(postControllerProvider.notifier).getPostById(postId));
final userPostsProvider =
    StreamProvider.family<List<PostModel>, List<CommunityModel>>(
        (ref, List<CommunityModel> communities) {
  final postController = ref.read(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchPostComments(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController(
      {required PostRepository postRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  void shareTextPost({
    required BuildContext ctx,
    required String title,
    required CommunityModel selectedCommunity,
    required String description,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final post = PostModel(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'text',
        createdAt: DateTime.now(),
        awards: [],
        description: description);

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(ctx, l.message), (r) {
      showSnackBar(ctx, "Posted Successfully");
      Routemaster.of(ctx).pop();
    });
  }

  void shareLinkPost({
    required BuildContext ctx,
    required String title,
    required CommunityModel selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final post = PostModel(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'link',
        createdAt: DateTime.now(),
        awards: [],
        link: link);

    final res = await _postRepository.addPost(post);
    state = false;
    res.fold((l) => showSnackBar(ctx, l.message), (r) {
      showSnackBar(ctx, "Posted Successfully");
      Routemaster.of(ctx).pop();
    });
  }

  void shareImagePost({
    required BuildContext ctx,
    required String title,
    required CommunityModel selectedCommunity,
    File? file,
    Uint8List? webFile,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final imageRes = await _storageRepository.storeFile(
        path: 'posts/${selectedCommunity.name}', id: postId, file: file);

    imageRes.fold((l) => showSnackBar(ctx, l.message), (imageUrl) async {
      final post = PostModel(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'image',
        createdAt: DateTime.now(),
        awards: [],
        link: imageUrl,
      );
      final res = await _postRepository.addPost(post);
      state = false;
      res.fold((l) => showSnackBar(ctx, l.message), (r) {
        showSnackBar(ctx, 'Posted successfully!');
        Routemaster.of(ctx).pop();
      });
    });
  }

  Stream<List<PostModel>> fetchUserPosts(List<CommunityModel> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  void deletePost(PostModel post) async {
    final res = await _postRepository.deletePost(post);
    res.fold((l) => null, (r) => null);
  }

  void upvote(PostModel post) {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.upvote(post, uid);
  }

  void downvote(PostModel post) {
    final uid = _ref.read(userProvider)!.uid;
    _postRepository.downvote(post, uid);
  }

  Stream<PostModel> getPostById(String postId) =>
      _postRepository.getPostById(postId);

  void addComment({
    required BuildContext ctx,
    required String text,
    required PostModel post,
  }) async {
    final user = _ref.read(userProvider)!;
    String commentId = const Uuid().v1();
    final comment = CommentModel(
        id: commentId,
        text: text,
        createdAt: DateTime.now(),
        postId: post.id,
        username: user.name,
        profilePic: user.profilePic);

    final res = await _postRepository.addComment(comment);
    res.fold((l) => showSnackBar(ctx, l.message), (r) => null);
  }

  Stream<List<CommentModel>> fetchPostComments(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }
}
