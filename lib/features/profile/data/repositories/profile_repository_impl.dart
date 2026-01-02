import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<UserProfile?> getProfile(String userId) async {
    final model = await _remoteDataSource.getProfile(userId);
    return model?.toEntity('');
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    final model = UserProfileModel.fromEntity(profile);
    await _remoteDataSource.saveProfile(model);
  }

  @override
  Stream<UserProfile?> getProfileStream(String userId) {
    return _remoteDataSource.getProfileStream(userId).map((model) {
      return model?.toEntity('');
    });
  }
}
