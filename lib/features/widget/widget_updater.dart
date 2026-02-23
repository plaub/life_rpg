import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../avatar/presentation/providers/avatar_providers.dart';
import '../home/presentation/providers/home_providers.dart';
import 'widget_service.dart';

/// Provider that watches avatar progress & home stats,
/// and pushes updates to the Android home screen widget.
final widgetUpdaterProvider = Provider<void>((ref) {
  final avatarProgressAsync = ref.watch(avatarProgressProvider);
  final homeStatsAsync = ref.watch(homeStatsProvider);

  // Only update when both have data
  final progress = avatarProgressAsync.asData?.value;
  final stats = homeStatsAsync.asData?.value;

  if (progress != null && stats != null) {
    final hours = stats.totalTime.inHours;
    final minutes = stats.totalTime.inMinutes.remainder(60);
    final timeFormatted = '${hours}h ${minutes}m';

    WidgetService.updateWidget(
      displayName: progress.avatar.name,
      level: progress.level,
      xpCurrent: progress.xpCurrent,
      xpTotal: progress.xpTotal,
      totalXp: progress.totalXp,
      totalSkills: stats.totalSkills,
      totalTimeFormatted: timeFormatted,
    );
  }
});
