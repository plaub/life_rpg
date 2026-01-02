import '../logic/xp_calculator.dart';
import 'skill.dart';

class SkillLog {
  final String id;
  final String userId;
  final Skill skill;

  final DateTime date;
  final String? note;

  final SkillSessionType sessionType;
  final List<SkillSessionTag> tags;
  final int? durationMinutes;

  final int xpEarned;
  final DateTime createdAt;

  const SkillLog({
    required this.id,
    required this.userId,
    required this.skill,
    required this.date,
    this.note,
    this.sessionType = SkillSessionType.apply,
    this.tags = const [],
    this.durationMinutes,
    required this.xpEarned,
    required this.createdAt,
  });
}
