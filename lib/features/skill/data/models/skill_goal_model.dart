import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/skill.dart';
import '../../domain/entities/skill_goal.dart';

class SkillGoalModel {
  final String id;
  final String userId;
  final String skillId;

  final SkillGoalType type;
  final int targetCount;
  final int currentCount;

  final DateTime periodStart;
  final DateTime periodEnd;

  final bool completed;

  const SkillGoalModel({
    required this.id,
    required this.userId,
    required this.skillId,
    required this.type,
    required this.targetCount,
    required this.currentCount,
    required this.periodStart,
    required this.periodEnd,
    required this.completed,
  });

  factory SkillGoalModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SkillGoalModel(
      id: doc.id,
      userId: data['userId'] as String,
      skillId: data['skillId'] as String,
      type: SkillGoalType.values.firstWhere(
        (e) => e.name == (data['type'] as String),
        orElse: () => SkillGoalType.weekly,
      ),
      targetCount: (data['targetCount'] as num).toInt(),
      currentCount: (data['currentCount'] as num).toInt(),
      periodStart: (data['periodStart'] as Timestamp).toDate(),
      periodEnd: (data['periodEnd'] as Timestamp).toDate(),
      completed: data['completed'] as bool,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'skillId': skillId,
      'type': type.name,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'periodStart': Timestamp.fromDate(periodStart),
      'periodEnd': Timestamp.fromDate(periodEnd),
      'completed': completed,
    };
  }

  SkillGoal toEntity(Skill skill) {
    return SkillGoal(
      id: id,
      userId: userId,
      skill: skill,
      type: type,
      targetCount: targetCount,
      currentCount: currentCount,
      periodStart: periodStart,
      periodEnd: periodEnd,
      completed: completed,
    );
  }

  factory SkillGoalModel.fromEntity(SkillGoal goal) {
      return SkillGoalModel(
          id: goal.id,
          userId: goal.userId,
          skillId: goal.skill.id,
          type: goal.type,
          targetCount: goal.targetCount,
          currentCount: goal.currentCount,
          periodStart: goal.periodStart,
          periodEnd: goal.periodEnd,
          completed: goal.completed,
      );
  }
}
