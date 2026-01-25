import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/exceptions/auth_exceptions.dart';
import '../models/user_model.dart';

/// Firebase Auth datasource - wrapper around FirebaseAuth API.
/// Handles direct communication with Firebase Authentication.
class FirebaseAuthDatasource {
  FirebaseAuthDatasource(this._firebaseAuth);

  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Stream of authentication state changes
  Stream<UserModel?> authStateChanges() {
    return _firebaseAuth.userChanges().map((firebaseUser) {
      return firebaseUser != null
          ? UserModel.fromFirebaseUser(firebaseUser)
          : null;
    });
  }

  /// Get current user
  UserModel? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser != null
        ? UserModel.fromFirebaseUser(firebaseUser)
        : null;
  }

  /// Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Create user with email and password
  Future<UserModel> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebaseUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Sign in anonymously
  Future<UserModel> signInAnonymously() async {
    try {
      final credential = await _firebaseAuth.signInAnonymously();
      return UserModel.fromFirebaseUser(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Update email
  Future<void> updateEmail(String email) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw const UserNotFoundException();
    try {
      await user.verifyBeforeUpdateEmail(email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Update password
  Future<void> updatePassword(String password) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw const UserNotFoundException();
    try {
      await user.updatePassword(password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Re-authenticate with password
  Future<void> reauthenticateWithPassword(String password) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw const UserNotFoundException();

    // Create credential and reauthenticate
    final credential = firebase_auth.EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    try {
      await user.reauthenticateWithCredential(credential);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Link email and password to current account
  Future<UserModel> linkEmailPassword({
    required String email,
    required String password,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw const UserNotFoundException();

    final credential = firebase_auth.EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    try {
      final userCredential = await user.linkWithCredential(credential);
      await userCredential.user!.reload();
      return UserModel.fromFirebaseUser(_firebaseAuth.currentUser!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  /// Handle Firebase Auth exceptions and convert to domain-specific exceptions
  Exception _handleFirebaseAuthException(
    firebase_auth.FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'user-not-found':
        return const UserNotFoundException();
      case 'wrong-password':
        return const WrongPasswordException();
      case 'email-already-in-use':
        return const EmailAlreadyInUseException();
      case 'invalid-email':
        return const InvalidEmailException();
      case 'weak-password':
        return const WeakPasswordException();
      default:
        return AuthException(e.message);
    }
  }
}
