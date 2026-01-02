import 'skill.dart';

enum SkillGoalType {
  weekly,
  monthly,
}

class SkillGoal {
  final String id;
  final String userId;
  final Skill skill;

  final SkillGoalType type;
  final int targetCount;
  final int currentCount;

  final DateTime periodStart;
  final DateTime periodEnd;

  final bool completed;

  const SkillGoal({
    required this.id,
    required this.userId,
    required this.skill,
    required this.type,
    required this.targetCount,
    required this.currentCount,
    required this.periodStart,
    required this.periodEnd,
    required this.completed,
  });
}
