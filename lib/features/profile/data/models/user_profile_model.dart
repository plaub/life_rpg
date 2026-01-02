import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile.dart';

class UserProfileModel {
  final String id;
  final String displayName;
  final int? age;
  final String? bio;

  const UserProfileModel({
    required this.id,
    required this.displayName,
    this.age,
    this.bio,
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (displayName.isNotEmpty) 'displayName': displayName,
      if (age != null) 'age': age,
      if (bio != null) 'bio': bio,
    };
  }

  UserProfile toEntity(String email) {
    return UserProfile(
      id: id,
      displayName: displayName,
      email: email,
      age: age,
      bio: bio,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      displayName: entity.displayName,
      age: entity.age,
      bio: entity.bio,
    );
  }
}
