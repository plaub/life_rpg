class UserProfile {
  final String id; // Matches Auth UID
  final String displayName;
  final String email;
  final int? age;
  final String? bio;

  const UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    this.age,
    this.bio,
  });

  UserProfile copyWith({
    String? displayName,
    String? email,
    int? age,
    String? bio,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      age: age ?? this.age,
      bio: bio ?? this.bio,
    );
  }
}
