import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getProfile(String userId);
  Future<void> saveProfile(UserProfile profile);
  Stream<UserProfile?> getProfileStream(String userId);
}
