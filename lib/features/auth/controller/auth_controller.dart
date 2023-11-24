import 'package:dialogix/features/auth/repository/auth_repository.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';
import '../../../models/user_model.dart';

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, bool>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userProvider = StateProvider<UserModel?>((ref) => null);


final authStateChangeProvider = StreamProvider.autoDispose<User?>(
    (ref) => ref.watch(authControllerProvider.notifier).authStateChange);

final getUserDataProvider = StreamProvider.family
    .autoDispose<UserModel, String>((ref, String uid) =>
        ref.watch(authControllerProvider.notifier).getUserData(uid));

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Stream<UserModel> getUserData(String uid) => _authRepository.getUserData(uid);

  void signInWithGoogle(BuildContext ctx, bool isFromLogin) async {
    state = true;
    final user = await _authRepository.signInWithGoogle(isFromLogin);
    state = false;
    user.fold(
        (l) => showSnackBar(ctx, l.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  void signInAsGuest(BuildContext ctx) async {
    state = true;

    final guestUser = await _authRepository.signInAsGuest();
    state = false;
    guestUser.fold(
        (l) => showSnackBar(ctx, l.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  void logOut() {
    // _ref.invalidate(userCommunitiesProvider);
    if (_ref.read(userProvider.notifier).state != null) {
      _ref.read(userProvider.notifier).update((state) => null);
    }
    _authRepository.logOut();
    if (_ref.read(userProvider.notifier).state != null) {
      _ref.read(userProvider.notifier).update((state) => null);
    }
  }
}
