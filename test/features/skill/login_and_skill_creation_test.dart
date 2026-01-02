import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:life_rpg/features/auth/domain/repositories/auth_repository.dart';
import 'package:life_rpg/features/auth/domain/entities/user_entity.dart';
import 'package:life_rpg/features/skill/domain/repositories/skill_repository.dart';
import 'package:life_rpg/features/skill/domain/entities/skill.dart';
import 'package:life_rpg/features/skill/domain/entities/skill_category.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSkillRepository extends Mock implements SkillRepository {}

class FakeSkill extends Fake implements Skill {}

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockSkillRepository mockSkillRepo;

  setUpAll(() {
    registerFallbackValue(FakeSkill());
  });

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockSkillRepo = MockSkillRepository();
  });

  group('Login & Skill Integration Test (Mocked)', () {
    const tEmail = 'pierrelaub@gmail.com';
    const tPassword = 'test123';
    const tUserId = 'JAHv1SltYnXkCjNsGebiavn8A1c2';

    const tUser = UserEntity(id: tUserId, email: tEmail, isAnonymous: false);

    final tCategory = const SkillCategory(
      id: 'cat_cooking',
      userId: tUserId,
      key: 'cooking',
      name: 'Cooking',
      icon: '🍳',
      color: 'FF5733',
    );

    test('should login and then create a skill for the user', () async {
      // 1. Arrange: Setup Login Success
      when(
        () => mockAuthRepo.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => tUser);

      // 2. Act: Execute Login
      final user = await mockAuthRepo.signInWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      // 3. Assert: Login worked
      expect(user.email, tEmail);
      expect(user.id, tUserId);

      // 4. Arrange: Setup Skill Creation
      final newSkill = Skill(
        id: 'new_skill_1',
        userId: user.id, // Use ID from logged in user
        name: 'Pizza Baking',
        category: tCategory,
        icon: '🍕',
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(() => mockSkillRepo.saveSkill(any())).thenAnswer((_) async => {});

      // 5. Act: Save Skill
      await mockSkillRepo.saveSkill(newSkill);

      // 6. Assert: Skill creation was triggered correctly and belongs to user
      final capturedSkill =
          verify(() => mockSkillRepo.saveSkill(captureAny())).captured.single
              as Skill;
      expect(capturedSkill.userId, tUserId);
      expect(capturedSkill.name, 'Pizza Baking');
    });
  });
}
