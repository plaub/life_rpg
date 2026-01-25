import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/repositories/firebase_auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/guest_login_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/link_email_password_usecase.dart';

/// Provider for Firebase Auth instance
final firebaseAuthProvider = Provider<firebase_auth.FirebaseAuth>((ref) {
  return firebase_auth.FirebaseAuth.instance;
});

/// Provider for Firebase Auth Datasource
final firebaseAuthDatasourceProvider = Provider<FirebaseAuthDatasource>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthDatasource(firebaseAuth);
});

/// Provider for Auth Repository (interface)
/// This is the key abstraction - presentation layer only knows this interface
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.watch(firebaseAuthDatasourceProvider);
  return FirebaseAuthRepositoryImpl(datasource);
});

/// Provider for Login UseCase
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

/// Provider for SignUp UseCase
final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpUseCase(repository);
});

/// Provider for Guest Login UseCase
final guestLoginUseCaseProvider = Provider<GuestLoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GuestLoginUseCase(repository);
});

/// Provider for Link Email Password UseCase
final linkEmailPasswordUseCaseProvider = Provider<LinkEmailPasswordUseCase>((
  ref,
) {
  final repository = ref.watch(authRepositoryProvider);
  return LinkEmailPasswordUseCase(repository);
});

/// Provider for Logout UseCase
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

/// Provider for Auth State Stream
/// UI can watch this to react to auth state changes
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
});

/// Provider for current user
final currentUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (err, stack) => null,
  );
});
