import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/core/constants/firebase_constants.dart';
import 'package:dialogix/core/failure.dart';
import 'package:dialogix/core/providers/firebase_providers.dart';
import 'package:dialogix/core/type_defs.dart';
import 'package:dialogix/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Provider for the AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firestore = ref.read(firestoreProvider);
  final auth = ref.read(authProvider);
  final googleSignIn = ref.read(googleSignInProvider);
  return AuthRepository(
    firestore: firestore,
    auth: auth,
    googleSignIn: googleSignIn,
  );
});

// Repository class for handling authentication-related tasks
class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  // Reference to the 'users' collection in Firestore
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  // Method to sign in using Google credentials
  //   Future<Either<String, UserModel>>
  FutureEither<UserModel> signInWithGoogle() async {
    try {
      // Sign in with Google
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );

      // Get user credentials
      final userCredential = await _auth.signInWithCredential(credential);

      // Extract user information
      final user = userCredential.user!;
      final UserModel userModel;

      // Check if the user is a new user
      if (userCredential.additionalUserInfo!.isNewUser) {
        // Create a UserModel for the new user
        userModel = UserModel(
          name: user.displayName ?? "Guest User",
          profilePic: user.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: user.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [],
        );

        // Add the new user to the 'users' collection in Firestore
        await _users.doc(userModel.uid).set(userModel.toJson());
      } else {
        userModel = await getUserData(user.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e
          .message!; // by throwing it, it will make sure that it goes to the next catch block  which will catch it over next catch block and return left
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) => _users
      .doc(uid)
      .snapshots()
      .map((event) => UserModel.fromJson(event.data() as Map<String, dynamic>));

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
