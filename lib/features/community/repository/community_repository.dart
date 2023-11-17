import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogix/core/constants/firebase_constants.dart';
import 'package:dialogix/core/failure.dart';
import 'package:dialogix/core/providers/firebase_providers.dart';
import 'package:dialogix/core/type_defs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../models/community_model.dart';

final communityRepositoryProvider = Provider<CommunityRepository>(
    (ref) => CommunityRepository(firestore: ref.read(firestoreProvider)));

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);

  FutureVoid createCommunity(CommunityModel community) async {
    try {
      var communityDoc = await _communities.doc(community.id).get();
      if (communityDoc.exists) {
        throw 'Community already exists';
      }
      return right(_communities.doc(community.id).set(community.toJson()));
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<CommunityModel> getCommunityByName(String name) =>
      _communities.doc(name).snapshots().map((event) =>
          CommunityModel.fromJson(event.data() as Map<String, dynamic>));

  Stream<List<CommunityModel>> getUserCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<CommunityModel> communities = [];
      for (var doc in event.docs) {
        communities
            .add(CommunityModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  FutureVoid editCommunity(CommunityModel community) async {
    try {
      return right(_communities
          .doc(community.name.toLowerCase())
          .update(community.toJson()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communities
        .where('id',
            isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
            isLessThan: query.isEmpty
                ? null
                : query.substring(0, query.length - 1) +
                    String.fromCharCode(
                      query.codeUnitAt(query.length - 1) + 1,
                    ))
        .snapshots()
        .map((event) {
      List<CommunityModel> communities = [];

      for (var community in event.docs) {
        communities.add(
            CommunityModel.fromJson(community.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  FutureVoid joinCommunity(String communityId, String userId) async {
    try {
      return right(_communities.doc(communityId).update({
        "members": FieldValue.arrayUnion([userId])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityId, String userId) async {
    try {
      return right(_communities.doc(communityId).update({
        "members": FieldValue.arrayRemove([userId])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addMods(String communityId, List<String> uids) async {
    try {
      return right(_communities.doc(communityId).update({"mods": uids}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
