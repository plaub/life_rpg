import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for creating a new user account.
class SignUpUseCase {
  const SignUpUseCase(this._authRepository);

  final AuthRepository _authRepository;

  /// Execute sign up with provided credentials.
  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    return await _authRepository.signUpWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
