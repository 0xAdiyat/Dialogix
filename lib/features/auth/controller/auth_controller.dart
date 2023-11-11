import 'package:dialogix/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});

class AuthController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  void signInWithGoogle(BuildContext ctx) async {
    final user = await _authRepository.signInWithGoogle();
    user.fold((l) => showSnackBar(ctx, l.message), (r) => null);
  }
}
