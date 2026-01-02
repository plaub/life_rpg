import '../repositories/auth_repository.dart';

/// Use case for logging out the current user.
class LogoutUseCase {
  const LogoutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  /// Execute logout.
  Future<void> call() async {
    await _authRepository.signOut();
  }
}
