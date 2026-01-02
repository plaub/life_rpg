/// Base class for all authentication exceptions.
class AuthException implements Exception {
  const AuthException([this.message]);
  final String? message;

  @override
  String toString() => message ?? 'AuthException';
}

/// Thrown when a user is not found.
class UserNotFoundException extends AuthException {
  const UserNotFoundException() : super('User not found');
}

/// Thrown when the password is incorrect.
class WrongPasswordException extends AuthException {
  const WrongPasswordException() : super('Wrong password');
}

/// Thrown when an email is already associated with another account.
class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException() : super('Email already in use');
}

/// Thrown when an email address is invalid.
class InvalidEmailException extends AuthException {
  const InvalidEmailException() : super('Invalid email');
}

/// Thrown when a password is too weak.
class WeakPasswordException extends AuthException {
  const WeakPasswordException() : super('Weak password');
}
