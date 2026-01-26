import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile.dart';
import '../../../avatar/domain/entities/avatar_config.dart';

class UserProfileModel {
  final String id;
  final String displayName;
  final int? age;
  final String? bio;
  final Map<String, dynamic>? avatarConfig;

  const UserProfileModel({
    required this.id,
    required this.displayName,
    this.age,
    this.bio,
    this.avatarConfig,
  });

  factory UserProfileModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserProfileModel(
      id: snapshot.id,
      displayName: data?['displayName'] ?? '',
      age: data?['age'],
      bio: data?['bio'],
      avatarConfig: data?['avatarConfig'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (displayName.isNotEmpty) 'displayName': displayName,
      if (age != null) 'age': age,
      if (bio != null) 'bio': bio,
      if (avatarConfig != null) 'avatarConfig': avatarConfig,
    };
  }

  UserProfile toEntity(String email) {
    return UserProfile(
      id: id,
      displayName: displayName,
      email: email,
      age: age,
      bio: bio,
      avatarConfig: avatarConfig != null
          ? AvatarConfig.fromJson(avatarConfig!)
          : null,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      displayName: entity.displayName,
      age: entity.age,
      bio: entity.bio,
      avatarConfig: entity.avatarConfig?.toJson(),
    );
  }
}
