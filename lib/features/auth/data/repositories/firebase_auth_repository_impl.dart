import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

/// Firebase implementation of AuthRepository.
/// This is the ONLY place where Firebase is referenced in the auth feature's logic.
/// The domain layer only knows about the AuthRepository interface.
class FirebaseAuthRepositoryImpl implements AuthRepository {
  FirebaseAuthRepositoryImpl(this._datasource);

  final FirebaseAuthDatasource _datasource;

  @override
  Stream<UserEntity?> authStateChanges() {
    return _datasource.authStateChanges().map((userModel) {
      return userModel?.toEntity();
    });
  }

  @override
  UserEntity? get currentUser {
    final userModel = _datasource.currentUser;
    return userModel?.toEntity();
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userModel = await _datasource.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final userModel = await _datasource.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> signInAnonymously() async {
    final userModel = await _datasource.signInAnonymously();
    return userModel.toEntity();
  }

  @override
  Future<void> signOut() async {
    await _datasource.signOut();
  }

  @override
  Future<void> updateEmail(String newEmail) async {
    await _datasource.updateEmail(newEmail);
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    await _datasource.updatePassword(newPassword);
  }

  @override
  Future<void> reauthenticateWithPassword(String password) async {
    await _datasource.reauthenticateWithPassword(password);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _datasource.sendPasswordResetEmail(email);
  }
}
