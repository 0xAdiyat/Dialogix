import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/core/constants/firebase_constants.dart';
import 'package:dialogix/core/models/user_model.dart';
import 'package:dialogix/core/providers/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  final auth = ref.read(authProvider);
  final googleSignIn = ref.read(googleSignInProvider);
  return AuthRepository(
      firestore: firestore, auth: auth, googleSignIn: googleSignIn);
});

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _firestore = firestore,
        _auth = auth,
        _googleSignIn =
            googleSignIn; // as we can't access private variables using usual constructor, just like using this in java

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  void signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user!;

      final userModel = UserModel(
        name: user.displayName ?? "Guest User",
        profilePic: user.photoURL ?? Constants.avatarDefault,
        banner: Constants.bannerDefault,
        uid: user.uid,
        isAuthenticated: true,
        karma: 0,
        awards: [],
      );
      await _users.doc(userModel.uid).set(userModel.toJson());
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
