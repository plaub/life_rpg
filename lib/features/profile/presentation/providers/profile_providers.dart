import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return ProfileRemoteDataSource(firestore);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(remoteDataSource);
});

/// Stream of the current user's profile
final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);

  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfileStream(user.id).map((profile) {
    if (profile == null) {
      return UserProfile(id: user.id, displayName: '', email: user.email ?? '');
    }
    return profile.copyWith(email: user.email);
  });
});

/// Notifier to handle profile updates
class ProfileController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // Initial state is void (null)
    return;
  }

  Future<void> updateProfile({
    String? displayName,
    int? age,
    String? bio,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('User not logged in');

      final profileRepo = ref.read(profileRepositoryProvider);

      // Fetch current profile to preserve existing fields if not provided
      final currentProfile = await profileRepo.getProfile(user.id);

      final newProfile = UserProfile(
        id: user.id,
        displayName: displayName ?? currentProfile?.displayName ?? '',
        email: user.email ?? '', // Always use Auth email as source of truth
        age: age ?? currentProfile?.age,
        bio: bio ?? currentProfile?.bio,
      );

      await profileRepo.saveProfile(newProfile);
    });
  }
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, void>(() {
      return ProfileController();
    });
