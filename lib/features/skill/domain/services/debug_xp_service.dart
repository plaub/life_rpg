import 'package:uuid/uuid.dart';
import '../../domain/entities/skill.dart';
import '../../domain/entities/skill_log.dart';
import '../../domain/repositories/skill_repository.dart';
import '../../domain/logic/xp_calculator.dart';

class DebugXpService {
  final SkillRepository _repository;

  DebugXpService(this._repository);

  Future<void> addDebugXp(String userId, {int xp = 50, String? skillId}) async {
    // 1. Get or create a "Debug" skill
    Skill? targetSkill;

    if (skillId != null) {
      targetSkill = await _repository.getSkill(skillId);
    }

    if (targetSkill == null) {
      final skills = await _repository.getSkills(userId).first;

      if (skills.isEmpty) {
        // If no skills exist, we might need a category first.
        // For simplicity in debug, we'll try to find any category or create a dummy one if possible.
        // However, usually the user has at least one skill.
        // If not, we'll throw for now or handle it.
        final categories = await _repository.getCategories(userId).first;
        if (categories.isEmpty) {
          return; // Cannot add XP without a category/skill
        }

        final newSkill = Skill(
          id: const Uuid().v4(),
          userId: userId,
          name: 'Debug Skill',
          category: categories.first,
          icon: '🚀',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await _repository.saveSkill(newSkill);
        targetSkill = newSkill;
      } else {
        targetSkill = skills.first;
      }
    }

    // 2. Create a log entry
    final log = SkillLog(
      id: const Uuid().v4(),
      userId: userId,
      skill: targetSkill,
      date: DateTime.now(),
      xpEarned: xp,
      createdAt: DateTime.now(),
      sessionType: SkillSessionType.apply,
      note: 'Debug XP increment',
    );

    await _repository.createLog(log);
  }
}
