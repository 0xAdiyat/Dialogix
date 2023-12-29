import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogix/models/comment_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';
import '../../../models/community_model.dart';
import '../../../models/post_model.dart';

final postRepositoryProvider = Provider.autoDispose<PostRepository>(
    (ref) => PostRepository(firestore: ref.read(firestoreProvider)));

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

// Collection References
  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _comments =>
      _firestore.collection(FirebaseConstants.commentsCollection);
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid addPost(PostModel post) async {
    try {
      return right(_posts.doc(post.id).set(post.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PostModel>> fetchUserPosts(List<CommunityModel> communities) {
    return _posts
        .where("communityName",
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => PostModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  Query<PostModel> fetchUserPostsPaginationQuery(
      List<CommunityModel> communities) {
    return _posts
        .where("communityName",
            whereIn: communities.map((e) => e.name).toList())
        .orderBy('createdAt', descending: true)
        .withConverter(
            fromFirestore: (snapshot, _) =>
                PostModel.fromJson(snapshot.data()!),
            toFirestore: (post, _) => post.toJson());
  }

  Stream<List<PostModel>> fetchGuestPosts() {
    return _posts
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map((event) => event.docs
            .map((e) => PostModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  FutureVoid deletePost(PostModel post) async {
    try {
      return right(_posts.doc(post.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvote(PostModel post, String userId) {
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        "downvotes": FieldValue.arrayRemove([userId])
      });
    }
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        "upvotes": FieldValue.arrayRemove([userId])
      });
    } else {
      _posts.doc(post.id).update({
        "upvotes": FieldValue.arrayUnion([userId])
      });
    }
  }

  void downvote(PostModel post, String userId) {
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        "upvotes": FieldValue.arrayRemove([userId])
      });
    }
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        "downvotes": FieldValue.arrayRemove([userId])
      });
    } else {
      _posts.doc(post.id).update({
        "downvotes": FieldValue.arrayUnion([userId])
      });
    }
  }

  Stream<PostModel> getPostById(String postId) => _posts
      .doc(postId)
      .snapshots()
      .map((event) => PostModel.fromJson(event.data() as Map<String, dynamic>));

  // TODO: On remove comment gotta decrement
  FutureVoid addComment(CommentModel comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toJson());
      return right(_posts
          .doc(comment.postId)
          .update({'commentCount': FieldValue.increment(1)}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CommentModel>> getCommentsOfPost(String postId) => _comments
      .where('postId', isEqualTo: postId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((event) => event.docs
          .map((e) => CommentModel.fromJson(e.data() as Map<String, dynamic>))
          .toList());

  FutureVoid awardPost(PostModel post, String award, String senderId) async {
    try {
      _posts.doc(post.id).update({
        'awards': FieldValue.arrayUnion([award])
      });
      _users.doc(senderId).update({
        'awards': FieldValue.arrayRemove([award])
      });
      return right(_users.doc(post.uid).update({
        'awards': FieldValue.arrayUnion([award])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

}
