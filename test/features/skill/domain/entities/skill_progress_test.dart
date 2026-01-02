import 'package:flutter_test/flutter_test.dart';
import 'package:life_rpg/features/skill/domain/entities/skill.dart';
import 'package:life_rpg/features/skill/domain/entities/skill_category.dart';
import 'package:life_rpg/features/skill/domain/entities/skill_log.dart';
import 'package:life_rpg/features/skill/domain/entities/skill_progress.dart';
import 'package:life_rpg/features/skill/domain/logic/xp_calculator.dart';

void main() {
  group('SkillProgress Level Logic', () {
    final tSkill = Skill(
      id: '1',
      userId: 'u1',
      name: 'Test Skill',
      category: SkillCategory(
        id: 'c1',
        userId: 'u1',
        key: 'k',
        name: 'Cat',
        icon: '',
        color: '',
      ),
      icon: '',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    SkillLog createLog(int xp) {
      return SkillLog(
        id: 'l1',
        userId: 'u1',
        skill: tSkill,
        date: DateTime.now(),
        sessionType: SkillSessionType.learn,
        tags: [],
        xpEarned: xp,
        createdAt: DateTime.now(),
      );
    }

    test('0 XP -> Level 1, 0/50 progress', () {
      final logs = [createLog(0)];
      final progress = SkillProgress.fromLogs(
        id: 'p1',
        userId: 'u1',
        skill: tSkill,
        logs: logs,
      );

      expect(progress.level, 1);
      expect(progress.totalXp, 0);
      expect(progress.xpCurrent, 0);
      expect(
        progress.xpTotal,
        50,
      ); // Next level needs 50 total, so range is 50-0=50
    });

    test('50 XP -> Level 2, 0/150 progress (Range 50->200)', () {
      final logs = [createLog(50)];
      final progress = SkillProgress.fromLogs(
        id: 'p1',
        userId: 'u1',
        skill: tSkill,
        logs: logs,
      );

      expect(progress.level, 2);
      expect(progress.totalXp, 50);
      expect(progress.xpCurrent, 0); // At start of level 2
      expect(progress.xpTotal, 150); // 200 - 50 = 150
    });

    test('820 XP -> Level 5, 20/450 progress', () {
      final logs = [createLog(820)];
      final progress = SkillProgress.fromLogs(
        id: 'p1',
        userId: 'u1',
        skill: tSkill,
        logs: logs,
      );

      // floor(sqrt(820/50)) = 4 -> Index 4 -> Level 5
      expect(progress.level, 5);
      expect(progress.totalXp, 820);

      // Start of L5 (idx 4) = 50 * 16 = 800
      // Current = 820 - 800 = 20
      expect(progress.xpCurrent, 20);

      // Start of L6 (idx 5) = 50 * 25 = 1250
      // Range = 1250 - 800 = 450
      expect(progress.xpTotal, 450);
    });

    test('Example: Level 4 Boundary Check (449 XP -> L3, 450 XP -> L4)', () {
      // 450 XP = L4 start. Index 3. 50*9=450.

      // Case 1: 449 XP
      final p1 = SkillProgress.fromLogs(
        id: 'p1',
        userId: 'u1',
        skill: tSkill,
        logs: [createLog(449)],
      );
      // sqrt(449/50) = sqrt(8.98) = 2.99 -> Floor 2 -> Index 2 -> Level 3
      expect(p1.level, 3);
      expect(p1.totalXp, 449);
      // Start L3 (idx 2) = 50*4 = 200.
      // Current = 449 - 200 = 249.
      expect(p1.xpCurrent, 249);
      // Next L4 (idx 3) = 450.
      // Range = 450 - 200 = 250.
      expect(p1.xpTotal, 250);

      // Case 2: 450 XP
      final p2 = SkillProgress.fromLogs(
        id: 'p1',
        userId: 'u1',
        skill: tSkill,
        logs: [createLog(450)],
      );
      // sqrt(450/50) = sqrt(9) = 3 -> Floor 3 -> Index 3 -> Level 4
      expect(p2.level, 4);
      expect(p2.xpCurrent, 0);
      // Start L4 = 450. Next L5 = 50*16 = 800. Range = 800 - 450 = 350.
      expect(p2.xpTotal, 350);
    });
  });
}
