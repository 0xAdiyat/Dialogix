import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogix/core/enums/enums.dart';
import 'package:dialogix/core/providers/dynamic_link/dynamic_link_parameters_provider.dart';
import 'package:dialogix/features/auth/controller/auth_controller.dart';
import 'package:dialogix/features/post/repository/post_repository.dart';
import 'package:dialogix/features/user_profile/controller/user_profile_controller.dart';
import 'package:dialogix/models/comment_model.dart';
import 'package:dialogix/models/community_model.dart';
import 'package:dialogix/models/dynamic_link_query_model.dart';
import 'package:dialogix/models/post_model.dart';
import 'package:dialogix/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers/dynamic_link/firebase_dynamic_link_repository_provider.dart';
import '../../../core/providers/storage_repository_provider.dart';
import '../../../core/utils.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>(
    (ref) => PostController(
        postRepository: ref.read(postRepositoryProvider),
        ref: ref,
        storageRepository: ref.read(storageRepositoryProvider)));
final getPostByIdProvider = StreamProvider.family
    .autoDispose<PostModel, String>((ref, postId) =>
        ref.read(postControllerProvider.notifier).getPostById(postId));

final userPostsProvider =
    StreamProvider.family.autoDispose((ref, List<CommunityModel> communities) {
  final postController = ref.read(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final userPostsPaginationQueryProvider =
    Provider.family((ref, List<CommunityModel> communities) {
  final postController = ref.read(postControllerProvider.notifier);
  return postController.fetchUserPostsPaginationQuery(communities);
});

final guestPostsProvider = StreamProvider.autoDispose(
    (ref) => ref.read(postControllerProvider.notifier).fetchGuestPosts());

final getPostCommentsProvider =
    StreamProvider.family.autoDispose((ref, String postId) {
  final postController = ref.read(postControllerProvider.notifier);
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
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);
    state = false;
    res.fold((l) => showSnackBar(ctx, l.message), (r) {
      showSnackBar(ctx, "Posted Successfully");
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
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);
    state = false;
    res.fold((l) => showSnackBar(ctx, l.message), (r) {
      showSnackBar(ctx, "Posted Successfully");
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
        path: 'posts/${selectedCommunity.name}',
        id: postId,
        file: file,
        webFile: webFile);

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
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.imagePost);
      state = false;
      res.fold((l) => showSnackBar(ctx, l.message), (r) {
        showSnackBar(ctx, 'Posted successfully!');
      });
    });
  }

  Stream<List<PostModel>> fetchUserPosts(List<CommunityModel> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

  Query<PostModel> fetchUserPostsPaginationQuery(
      List<CommunityModel> communities) {
    // if (communities.isNotEmpty) {
    return _postRepository.fetchUserPostsPaginationQuery(communities);
    // }
  }

  Stream<List<PostModel>> fetchGuestPosts() =>
      _postRepository.fetchGuestPosts();

  void deletePost(PostModel post, BuildContext ctx, bool isAdminCallBtn) async {
    final res = await _postRepository.deletePost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);
    res.fold((l) => null, (r) {
      if (!isAdminCallBtn) {
        Navigator.of(ctx).pop();
        Navigator.of(ctx).pop();
      }
    });
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
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);
    res.fold((l) => showSnackBar(ctx, l.message), (r) => null);
  }

  Stream<List<CommentModel>> fetchPostComments(String postId) {
    return _postRepository.getCommentsOfPost(postId);
  }

  void awardPost(
      {required PostModel post,
      required String award,
      required BuildContext ctx}) async {
    UserModel user = _ref.read(userProvider)!;
    final res = await _postRepository.awardPost(post, award, user.uid);

    res.fold((l) => showSnackBar(ctx, l.message), (r) {
      _ref
          .read(userProfileControllerProvider.notifier)
          .updateUserKarma(UserKarma.awardPost);
      _ref.read(userProvider.notifier).update((state) {
        if (state != null) {
          // To resolve Unsupported operation: Cannot remove from an unmodifiable list

          // We created a new list
          final updatedAwards = List<String>.from(state.awards);

          updatedAwards.remove(award);

          // Create a new UserModel instance with the updated awards list
          final updatedUser = state.copyWith(awards: updatedAwards);

          return updatedUser;
        }
        return null;
      });
      Routemaster.of(ctx).pop();
    });
  }

  void createPostDynamicLink(BuildContext ctx, PostModel post) async {
    state = true;
    final res = await _ref
        .read(
          firebaseDynamicLinkProvider(
              parameters: _ref.read(dynamicLinkParametersProvider(
                  queries: [DynamicLinkQuery(key: "postId", value: post.id)],
                  path: "post",
                  postfixPath: "comments",
                  title: post.title))),
        )
        .createDynamicLink(true);

    state = false;

    return res.fold((l) {
      Navigator.of(ctx).pop();
      Navigator.of(ctx).pop();

      showSnackBar(ctx, l.message);
    }, (r) async {
      await Clipboard.setData(ClipboardData(text: r));

      if (mounted) {
        Navigator.of(ctx).pop();
        Navigator.of(ctx).pop();
      }
    });
  }
}
