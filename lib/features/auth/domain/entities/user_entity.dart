/// User entity - represents an authenticated user in the domain layer.
/// This is framework-agnostic and doesn't know about Firebase.
class UserEntity {
  const UserEntity({
    required this.id,
    required this.email,
    required this.isAnonymous,
  });

  final String id;
  final String? email;
  final bool isAnonymous;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          isAnonymous == other.isAnonymous;

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ isAnonymous.hashCode;

  @override
  String toString() => 'UserEntity(id: $id, email: $email, isAnonymous: $isAnonymous)';
}
