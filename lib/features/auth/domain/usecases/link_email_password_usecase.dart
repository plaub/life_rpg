import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case to link email and password to an existing anonymous account.
class LinkEmailPasswordUseCase {
  LinkEmailPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    return await _repository.linkEmailPassword(
      email: email,
      password: password,
    );
  }
}
