import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/skill.dart';
import '../../domain/entities/skill_log.dart';
import '../../domain/logic/xp_calculator.dart';

class SkillLogModel {
  final String id;
  final String userId;
  final String skillId;

  final DateTime date;
  final String? note;

  final SkillSessionType sessionType;
  final List<SkillSessionTag> tags;
  final int? durationMinutes;

  final int xpEarned;
  final DateTime createdAt;

  const SkillLogModel({
    required this.id,
    required this.userId,
    required this.skillId,
    required this.date,
    this.note,
    required this.sessionType,
    required this.tags,
    this.durationMinutes,
    required this.xpEarned,
    required this.createdAt,
  });

  factory SkillLogModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    // Handle sessionType (default to apply if missing/invalid)
    final typeString = data['sessionType'] as String?;
    final sessionType = SkillSessionType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => SkillSessionType.apply,
    );

    // Handle tags
    final safeTags = <SkillSessionTag>[];
    if (data['tags'] != null) {
      for (final t in (data['tags'] as List<dynamic>)) {
        try {
          final tag = SkillSessionTag.values.firstWhere((e) => e.name == t);
          safeTags.add(tag);
        } catch (_) {
          // Ignore invalid/unknown tags
        }
      }
    }

    return SkillLogModel(
      id: doc.id,
      userId: data['userId'] as String,
      skillId: data['skillId'] as String,
      date: (data['date'] as Timestamp).toDate(),
      note: data['note'] as String?,
      sessionType: sessionType,
      tags: safeTags,
      durationMinutes: (data['durationMinutes'] as num?)?.toInt(),
      xpEarned: (data['xpEarned'] as num).toInt(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'skillId': skillId,
      'date': Timestamp.fromDate(date),
      if (note != null) 'note': note,
      'sessionType': sessionType.name,
      'tags': tags.map((e) => e.name).toList(),
      if (durationMinutes != null) 'durationMinutes': durationMinutes,
      'xpEarned': xpEarned,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  SkillLog toEntity(Skill skill) {
    return SkillLog(
      id: id,
      userId: userId,
      skill: skill,
      date: date,
      note: note,
      sessionType: sessionType,
      tags: tags,
      durationMinutes: durationMinutes,
      xpEarned: xpEarned,
      createdAt: createdAt,
    );
  }

  factory SkillLogModel.fromEntity(SkillLog log) {
    return SkillLogModel(
      id: log.id,
      userId: log.userId,
      skillId: log.skill.id,
      date: log.date,
      note: log.note,
      sessionType: log.sessionType,
      tags: log.tags,
      durationMinutes: log.durationMinutes,
      xpEarned: log.xpEarned,
      createdAt: log.createdAt,
    );
  }
}
