class CategoryStats {
  final String categoryId;
  final String categoryName;
  final String categoryIcon; // e.g. "code", "fitness_center"
  final String categoryColor; // hex string
  final int totalXP;
  final Duration totalTime;
  final int skillCount;

  const CategoryStats({
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.totalXP,
    required this.totalTime,
    required this.skillCount,
  });
}

class HomeStats {
  final int totalXP;
  final Duration totalTime;
  final int totalSkills;
  final List<CategoryStats> categoryStats;

  const HomeStats({
    required this.totalXP,
    required this.totalTime,
    required this.totalSkills,
    required this.categoryStats,
  });

  // Empty state
  static const empty = HomeStats(
    totalXP: 0,
    totalTime: Duration.zero,
    totalSkills: 0,
    categoryStats: [],
  );
}
