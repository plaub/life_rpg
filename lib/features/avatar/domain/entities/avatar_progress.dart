import 'avatar.dart';
import '../../../skill/domain/logic/xp_calculator.dart';

class AvatarProgress {
  final String id;
  final String userId;
  final Avatar avatar;

  final int level;
  final int xpCurrent; // XP earned in current level
  final int xpTotal; // XP range of current level
  final int totalXp; // Lifetime accumulated XP

  final DateTime createdAt;
  final DateTime updatedAt;

  const AvatarProgress({
    required this.id,
    required this.userId,
    required this.avatar,
    required this.level,
    required this.xpCurrent,
    required this.xpTotal,
    required this.totalXp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AvatarProgress.initial({
    required String id,
    required String userId,
    required Avatar avatar,
  }) {
    final now = DateTime.now();
    final progress = LevelCalculator.getProgress(0, base: 100, growth: 1.6);
    return AvatarProgress(
      id: id,
      userId: userId,
      avatar: avatar,
      level: progress.$1,
      xpCurrent: progress.$2,
      xpTotal: progress.$3,
      totalXp: 0,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory AvatarProgress.calculate({
    required String id,
    required String userId,
    required Avatar avatar,
    required int totalXp,
  }) {
    final progress = LevelCalculator.getProgress(
      totalXp,
      base: 100,
      growth: 1.6,
    );
    final level = progress.$1;
    final xpCurrent = progress.$2;
    final xpTotalRange = progress.$3;

    final now = DateTime.now();

    return AvatarProgress(
      id: id,
      userId: userId,
      avatar: avatar,
      level: level,
      xpCurrent: xpCurrent,
      xpTotal: xpTotalRange,
      totalXp: totalXp,
      createdAt:
          now, // This should probably come from elsewhere if we are calculating from scratch
      updatedAt: now,
    );
  }

  AvatarProgress copyWith({
    String? id,
    String? userId,
    Avatar? avatar,
    int? level,
    int? xpCurrent,
    int? xpTotal,
    int? totalXp,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AvatarProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      avatar: avatar ?? this.avatar,
      level: level ?? this.level,
      xpCurrent: xpCurrent ?? this.xpCurrent,
      xpTotal: xpTotal ?? this.xpTotal,
      totalXp: totalXp ?? this.totalXp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
