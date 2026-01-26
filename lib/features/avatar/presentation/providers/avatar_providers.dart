import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/avatar.dart';
import '../../domain/entities/avatar_progress.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

final avatarProvider = Provider<Avatar?>((ref) {
  final user = ref.watch(currentUserProvider);
  final profile = ref.watch(userProfileProvider).value;

  if (user == null) return null;

  return Avatar(
    id: 'avatar_${user.id}',
    userId: user.id,
    name: profile?.displayName ?? 'Player',
    avatarUrl: '', // Could be derived from profile later
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
});

final avatarProgressProvider = Provider<AsyncValue<AvatarProgress?>>((ref) {
  final avatar = ref.watch(avatarProvider);
  final homeStatsAsync = ref.watch(homeStatsProvider);

  if (avatar == null) return const AsyncValue.data(null);

  return homeStatsAsync.when(
    data: (stats) {
      final progress = AvatarProgress.calculate(
        id: 'progress_${avatar.id}',
        userId: avatar.userId,
        avatar: avatar,
        totalXp: stats.totalXP,
      );
      return AsyncValue.data(progress);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
