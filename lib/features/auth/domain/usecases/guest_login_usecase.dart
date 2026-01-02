import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for anonymous/guest login.
class GuestLoginUseCase {
  const GuestLoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  /// Execute anonymous login.
  Future<UserEntity> call() async {
    return await _authRepository.signInAnonymously();
  }
}
