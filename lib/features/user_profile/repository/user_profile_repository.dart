import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogix/models/post_model.dart';
import 'package:dialogix/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/type_defs.dart';

final userProfileRepositoryProvider = Provider.autoDispose<UserProfileRepository>(
    (ref) => UserProfileRepository(firestore: ref.read(firestoreProvider)));

class UserProfileRepository {
  final FirebaseFirestore _firestore;

  UserProfileRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PostModel>> getUserPosts(String uid) {
    return _posts
        .where("uid", isEqualTo: uid)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => PostModel.fromJson(e.data() as Map<String, dynamic>))
            .toList());
  }

  FutureVoid updateUserKarma(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update({
        'karma': user.karma,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
