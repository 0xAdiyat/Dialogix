import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firestoreProvider = Provider.autoDispose<FirebaseFirestore>(
    (ref) => FirebaseFirestore.instance);

final authProvider =
    Provider.autoDispose<FirebaseAuth>((ref) => FirebaseAuth.instance);
final storageProvider =
    Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

final googleSignInProvider =
    Provider.autoDispose<GoogleSignIn>((ref) => GoogleSignIn());

final firebaseDynamicLinksProvider = Provider.autoDispose<FirebaseDynamicLinks>(
    (ref) => FirebaseDynamicLinks.instance);
