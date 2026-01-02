import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../../features/skill/presentation/providers/skill_providers.dart';
import '../../domain/entities/home_stats.dart';

final homeStatsProvider = FutureProvider.autoDispose<HomeStats>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return HomeStats.empty;

  final repository = ref.watch(skillRepositoryProvider);

  // Fetch all necessary data
  // We use .future to get the latest value from the streams
  final skills = await ref.watch(skillsProvider.future);
  final categories = await ref.watch(categoriesProvider.future);

  // getAllLogs is a Future in the repository
  final logs = await repository.getAllLogs(user.id);

  // 1. Calculate Global Stats
  int totalXP = 0;
  int totalMinutes = 0;

  for (final log in logs) {
    totalXP += log.xpEarned;
    if (log.durationMinutes != null) {
      totalMinutes += log.durationMinutes!;
    }
  }

  // 2. Prepare Category aggregations
  final Map<String, int> catXp = {};
  final Map<String, int> catTime = {};
  final Map<String, int> catSkillCount = {};

  // Initialize for all existing categories
  for (final cat in categories) {
    catXp[cat.id] = 0;
    catTime[cat.id] = 0;
    catSkillCount[cat.id] = 0;
  }

  // Aggregate stats from Logs
  for (final log in logs) {
    final catId = log.skill.category.id;
    // Handle case where category might have been deleted but log exists (if that's possible logic)
    // Here we just add to the ID.
    catXp[catId] = (catXp[catId] ?? 0) + log.xpEarned;
    if (log.durationMinutes != null) {
      catTime[catId] = (catTime[catId] ?? 0) + log.durationMinutes!;
    }
  }

  // Count Skills
  for (final skill in skills) {
    final catId = skill.category.id;
    catSkillCount[catId] = (catSkillCount[catId] ?? 0) + 1;
  }

  // Build CategoryStats objects
  final categoryStatsList = categories.map((cat) {
    return CategoryStats(
      categoryId: cat.id,
      categoryName: cat.name,
      categoryIcon: cat.icon,
      categoryColor: cat.color,
      totalXP: catXp[cat.id] ?? 0,
      totalTime: Duration(minutes: catTime[cat.id] ?? 0),
      skillCount: catSkillCount[cat.id] ?? 0,
    );
  }).toList();

  return HomeStats(
    totalXP: totalXP,
    totalTime: Duration(minutes: totalMinutes),
    totalSkills: skills.length,
    categoryStats: categoryStatsList,
  );
});
