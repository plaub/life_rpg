import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user_entity.dart';

/// User model - Data Transfer Object for Firebase.
/// Converts between Firebase User and domain's UserEntity.
class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.isAnonymous,
  });

  final String id;
  final String? email;
  final bool isAnonymous;

  /// Convert from Firebase User to UserModel
  factory UserModel.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email,
      isAnonymous: firebaseUser.isAnonymous,
    );
  }

  /// Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      isAnonymous: isAnonymous,
    );
  }
}
