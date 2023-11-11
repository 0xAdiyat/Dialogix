import 'package:dialogix/features/auth/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});

class AuthController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  void signInWithGoogle() {
    _authRepository.signInWithGoogle();
  }
}
