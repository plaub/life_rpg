import '../entities/user_entity.dart';

/// Abstract repository interface for authentication.
/// Implementations (like FirebaseAuthRepository) will provide concrete logic.
/// This keeps the domain layer independent of any specific backend.
abstract class AuthRepository {
  /// Stream of authentication state changes.
  /// Emits current user when authentication state changes, or null when logged out.
  Stream<UserEntity?> authStateChanges();

  /// Get current authenticated user, if any.
  UserEntity? get currentUser;

  /// Sign in with email and password.
  Future<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Create new user account with email and password.
  Future<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign in anonymously (guest mode).
  Future<UserEntity> signInAnonymously();

  /// Sign out current user.
  Future<void> signOut();

  /// Update user email.
  Future<void> updateEmail(String newEmail);

  /// Update user password.
  Future<void> updatePassword(String newPassword);

  /// Re-authenticate with password (required for sensitive changes like email/password)
  Future<void> reauthenticateWithPassword(String password);

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Link email and password to the current account (used for converting guest to permanent)
  Future<UserEntity> linkEmailPassword({
    required String email,
    required String password,
  });
}
