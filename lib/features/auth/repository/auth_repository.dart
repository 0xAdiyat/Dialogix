import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogix/core/constants/constants.dart';
import 'package:dialogix/core/constants/firebase_constants.dart';
import 'package:dialogix/core/failure.dart';
import 'package:dialogix/core/providers/firebase_providers.dart';
import 'package:dialogix/core/type_defs.dart';
import 'package:dialogix/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Provider for the AuthRepository
final authRepositoryProvider = Provider.autoDispose<AuthRepository>((ref) {
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
  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      // Get user credentials
      UserCredential userCredential;
      // Extract user info
      User user;

      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        userCredential = await _auth.signInWithPopup(googleProvider);
      }
      {
        // Sign in with Google
        final googleUser = await _googleSignIn.signIn();
        final googleAuth = await googleUser?.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken,
          accessToken: googleAuth?.accessToken,
        );

        if (isFromLogin) {
          userCredential = await _auth.signInWithCredential(credential);

          user = userCredential.user!;
        } else {
          try {
            userCredential =
                await _auth.currentUser!.linkWithCredential(credential);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'credential-already-in-use') {
              // Google account is already linked, handle accordingly

              //  extras: we can give the user option to unlink the old account
              return left(Failure('Google account is already linked.'));
            } else {
              // Re-throw other FirebaseAuthExceptions
              rethrow;
            }
          }

          user = userCredential.user!;
        }
      }

      UserModel userModel;

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
          awards: [
            'awesomeAns',
            'gold',
            'platinum',
            'helpful',
            'plusone',
            'rocket',
            'thankyou',
            'til',
          ],
        );

        // Add the new user to the 'users' collection in Firestore
        await _users.doc(userModel.uid).set(userModel.toJson());
      } else {
        userModel = await getUserData(user.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));

      // throw e
      //     .message!; // by throwing it, it will make sure that it goes to the next catch block  which will catch it over next catch block and return left
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      // Extract user information
      final user = userCredential.user!;

      // Create a UserModel for the new user
      final userModel = UserModel(
        name: 'Guest',
        profilePic: Constants.avatarDefault,
        banner: Constants.bannerDefault,
        uid: user.uid,
        isAuthenticated: false,
        karma: 0,
        awards: [],
      );

      // Add the new user to the 'users' collection in Firestore
      await _users.doc(userModel.uid).set(userModel.toJson());

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
