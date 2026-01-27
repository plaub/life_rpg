import 'package:flutter_test/flutter_test.dart';
import 'package:life_rpg/features/skill/domain/logic/xp_calculator.dart';

void main() {
  group('XPCalculator', () {
    test('Example 1: Learn (Short) - 20min, Learn, No Tags -> 36 XP', () {
      final xp = XPCalculator.calculateXP(
        durationMinutes: 20,
        sessionType: SkillSessionType.learn,
        tags: [],
      );
      // sqrt(20) = 4.47
      // Type: 0.8
      // Tags: 0
      // 10 * 4.47 * 0.8 = 35.76 -> round(35.76) = 36
      expect(xp, 36);
    });

    test('Example 2: Apply + Repeat - 45min, Apply, [repeat] -> 70 XP', () {
      final xp = XPCalculator.calculateXP(
        durationMinutes: 45,
        sessionType: SkillSessionType.apply,
        tags: [SkillSessionTag.repeat],
      );
      // sqrt(45) = 6.708
      // Type: 1.0
      // Tags: +0.05
      // 10 * 6.708 * 1.0 * 1.05 = 70.4 -> round(70.4) = 70
      expect(xp, 70);
    });

    test(
      'Example 3: Both + Challenge + Teach - 60min, Both, [challenge, teach] -> 112 XP',
      () {
        final xp = XPCalculator.calculateXP(
          durationMinutes: 60,
          sessionType: SkillSessionType.both,
          tags: [SkillSessionTag.challenge, SkillSessionTag.teach],
        );
        // sqrt(60) = 7.746
        // Type: 1.2
        // Tags: 0.1 + 0.1 = +0.2 (Cap reached essentially, but exact match)
        // 10 * 7.746 * 1.2 * 1.2 = 111.5 -> round(111.5) = 112
        expect(xp, 112);
      },
    );

    test('Tag Cap: Max 0.2 bonus', () {
      final xp = XPCalculator.calculateXP(
        durationMinutes: 100,
        sessionType: SkillSessionType.apply,
        tags: [
          SkillSessionTag.teach, // 0.1
          SkillSessionTag.challenge, // 0.1
          SkillSessionTag.review, // 0.05 -> Total 0.25 -> Cap 0.2
        ],
      );
      // sqrt(100) = 10
      // Type: 1.0
      // Tags: 1.2 (capped)
      // 10 * 10 * 1.0 * 1.2 = 120
      expect(xp, 120);
    });

    test('Zero duration should be 0 XP', () {
      final xp = XPCalculator.calculateXP(
        durationMinutes: 0,
        sessionType: SkillSessionType.both,
        tags: [],
      );
      expect(xp, 0);
    });

    test('Negative duration should be 0 XP', () {
      final xp = XPCalculator.calculateXP(
        durationMinutes: -10,
        sessionType: SkillSessionType.both,
        tags: [],
      );
      expect(xp, 0);
    });
  });
}
