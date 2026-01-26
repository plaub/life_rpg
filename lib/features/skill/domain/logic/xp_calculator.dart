import 'dart:math';

enum SkillSessionType {
  learn,
  apply,
  both;

  double get factor {
    switch (this) {
      case SkillSessionType.learn:
        return 0.8;
      case SkillSessionType.apply:
        return 1.0;
      case SkillSessionType.both:
        return 1.2;
    }
  }

  String get displayName {
    switch (this) {
      case SkillSessionType.learn:
        return 'Learn';
      case SkillSessionType.apply:
        return 'Apply';
      case SkillSessionType.both:
        return 'Both';
    }
  }
}

enum SkillSessionTag {
  repeat,
  review,
  teach,
  experiment,
  challenge;

  double get bonus {
    switch (this) {
      case SkillSessionTag.repeat:
        return 0.05;
      case SkillSessionTag.review:
        return 0.05;
      case SkillSessionTag.teach:
        return 0.1;
      case SkillSessionTag.experiment:
        return 0.05;
      case SkillSessionTag.challenge:
        return 0.1;
    }
  }

  String get displayName {
    // Capitalize first letter
    return name[0].toUpperCase() + name.substring(1);
  }
}

class XPCalculator {
  static int calculateXP({
    required int durationMinutes,
    required SkillSessionType sessionType,
    required List<SkillSessionTag> tags,
  }) {
    if (durationMinutes <= 0) return 0;

    // 1. Time Factor: sqrt(duration)
    final timeFactor = sqrt(durationMinutes);

    // 2. Session Type Factor
    final typeFactor = sessionType.factor;

    // 3. Tag Factor (capped at 0.2)
    final totalTagBonus = tags.fold<double>(0.0, (sum, tag) => sum + tag.bonus);
    final tagFactor = 1 + min(totalTagBonus, 0.2);

    // Final Formula: round(sqrt(durationMinutes) * sessionTypeFactor * (1 + tagFactor))
    return (timeFactor * typeFactor * tagFactor).round();
  }
}

class LevelCalculator {
  // Base XP defining the scale
  // Growth defining the exponential increase
  // Formula: totalXP = base * (growth^(level-1) - 1)
  // Inverse: level = floor(log(totalXP/base + 1) / log(growth)) + 1

  static int calculateLevel(
    int totalXp, {
    int base = 100,
    double growth = 1.4,
  }) {
    if (totalXp <= 0) return 1;
    final level = (log(totalXp / base + 1) / log(growth)).floor() + 1;
    return level;
  }

  static int getXpStartOfLevel(
    int level, {
    int base = 100,
    double growth = 1.4,
  }) {
    if (level <= 1) return 0;
    return (base * (pow(growth, level - 1) - 1)).round();
  }

  static (int level, int xpCurrent, int xpTotalRange) getProgress(
    int totalXp, {
    int base = 100,
    double growth = 1.4,
  }) {
    final level = calculateLevel(totalXp, base: base, growth: growth);
    final startOfCurrent = getXpStartOfLevel(level, base: base, growth: growth);
    final startOfNext = getXpStartOfLevel(
      level + 1,
      base: base,
      growth: growth,
    );

    return (level, totalXp - startOfCurrent, startOfNext - startOfCurrent);
  }
}
