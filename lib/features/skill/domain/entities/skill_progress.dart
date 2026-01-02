import 'dart:math';
import 'skill.dart';
import 'skill_log.dart';

class SkillProgress {
  final String id;
  final String userId;
  final Skill skill;

  final int level;
  final int xpCurrent; // XP earned in current level
  final int
  xpTotal; // XP range of current level (xpStartOfNext - xpStartOfCurrent)
  final int totalXp; // Lifetime accumulated XP

  final DateTime? lastPracticedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SkillProgress({
    required this.id,
    required this.userId,
    required this.skill,
    required this.level,
    required this.xpCurrent,
    required this.xpTotal,
    required this.totalXp,
    this.lastPracticedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SkillProgress.initial({
    required String id,
    required String userId,
    required Skill skill,
  }) {
    final now = DateTime.now();
    return SkillProgress(
      id: id,
      userId: userId,
      skill: skill,
      level: 1,
      xpCurrent: 0,
      xpTotal: 50, // Level 1 requires 50 XP to reach Level 2
      totalXp: 0,
      createdAt: now,
      updatedAt: now,
    );
  }

  SkillProgress copyWith({
    String? id,
    String? userId,
    Skill? skill,
    int? level,
    int? xpCurrent,
    int? xpTotal,
    int? totalXp,
    DateTime? lastPracticedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SkillProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      skill: skill ?? this.skill,
      level: level ?? this.level,
      xpCurrent: xpCurrent ?? this.xpCurrent,
      xpTotal: xpTotal ?? this.xpTotal,
      totalXp: totalXp ?? this.totalXp,
      lastPracticedAt: lastPracticedAt ?? this.lastPracticedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory SkillProgress.fromLogs({
    required String? id,
    required String userId,
    required Skill skill,
    required List<SkillLog> logs,
  }) {
    // 1. Sort logs by date ascending
    final sortedLogs = List<SkillLog>.from(logs)
      ..sort((a, b) => a.date.compareTo(b.date));

    if (sortedLogs.isEmpty) {
      return SkillProgress.initial(
        id: id ?? 'calculated',
        userId: userId,
        skill: skill,
      );
    }

    // 2. Calculate Total XP
    final totalXp = sortedLogs.fold<int>(0, (sum, log) => sum + log.xpEarned);

    // 3. Level Calculation
    // Formula: level = floor(sqrt(totalXP / 50)) + 1
    const baseLevelXp = 50;

    final calculatedIndex = sqrt(totalXp / baseLevelXp).floor();
    final level = calculatedIndex + 1;

    // Boundary Calculation: StartXP(L) = 50 * (L-1)^2
    int getXpStartOfLevel(int l) {
      if (l <= 1) return 0;
      final idx = l - 1;
      return baseLevelXp * idx * idx;
    }

    final xpStartOfCurrentLevel = getXpStartOfLevel(level);
    final xpStartOfNextLevel = getXpStartOfLevel(level + 1);

    final xpCurrent = totalXp - xpStartOfCurrentLevel;
    final xpTotalRange = xpStartOfNextLevel - xpStartOfCurrentLevel;

    // Last Practiced
    final lastDate = sortedLogs.last.date;
    final now = DateTime.now();

    return SkillProgress(
      id: id ?? 'calculated',
      userId: userId,
      skill: skill,
      level: level,
      xpCurrent: xpCurrent,
      xpTotal: xpTotalRange,
      totalXp: totalXp,
      lastPracticedAt: lastDate,
      createdAt: sortedLogs.first.createdAt,
      updatedAt: now,
    );
  }
}
