import '../../../avatar/domain/entities/avatar_config.dart';

class UserProfile {
  final String id; // Matches Auth UID
  final String displayName;
  final String email;
  final int? age;
  final String? bio;
  final AvatarConfig? avatarConfig;

  const UserProfile({
    required this.id,
    required this.displayName,
    required this.email,
    this.age,
    this.bio,
    this.avatarConfig,
  });

  UserProfile copyWith({
    String? displayName,
    String? email,
    int? age,
    String? bio,
    AvatarConfig? avatarConfig,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      avatarConfig: avatarConfig ?? this.avatarConfig,
    );
  }
}
