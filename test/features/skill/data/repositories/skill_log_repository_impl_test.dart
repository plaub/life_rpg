import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:life_rpg/features/skill/data/datasources/skill_remote_datasource.dart';
import 'package:life_rpg/features/skill/data/models/skill_log_model.dart';
import 'package:life_rpg/features/skill/data/repositories/skill_log_repository_impl.dart';
import 'package:life_rpg/features/skill/domain/repositories/skill_repository.dart';
import 'package:life_rpg/features/skill/domain/entities/skill.dart';
import 'package:life_rpg/features/skill/domain/entities/skill_category.dart';
import 'package:life_rpg/features/skill/domain/logic/xp_calculator.dart';

class MockSkillRemoteDataSource extends Mock implements SkillRemoteDataSource {}

class MockSkillRepository extends Mock implements SkillRepository {}

void main() {
  late SkillLogRepositoryImpl repository;
  late MockSkillRemoteDataSource mockDataSource;
  late MockSkillRepository mockSkillRepository;

  setUp(() {
    mockDataSource = MockSkillRemoteDataSource();
    mockSkillRepository = MockSkillRepository();
    repository = SkillLogRepositoryImpl(mockDataSource, mockSkillRepository);
  });

  group('SkillLogRepositoryImpl', () {
    final tSkill = Skill(
      id: 'skill_1',
      userId: 'user_1',
      name: 'Pizza Cooking',
      category: const SkillCategory(
        id: 'cat_1',
        userId: 'user_1',
        key: 'cooking',
        name: 'Cooking',
        icon: '🍳',
        color: 'FF5733',
      ),
      icon: '🍕',
      isActive: true,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    );

    final tLogModel = SkillLogModel(
      id: 'log_1',
      userId: 'user_1',
      skillId: 'skill_1',
      date: DateTime(2025, 1, 12),
      note: 'Delicious!',
      sessionType: SkillSessionType.apply,
      tags: [],
      xpEarned: 60,
      createdAt: DateTime(2025, 1, 12),
    );

    test('getLogsForSkill should join Skill entity', () async {
      // arrange
      // First we must allow getSkill to be called
      when(
        () => mockSkillRepository.getSkill(any()),
      ).thenAnswer((_) async => tSkill);

      // Then we expect getLogsForSkill with userId from tSkill
      when(
        () => mockDataSource.getLogsForSkill(
          any(),
          any(),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => [tLogModel]);

      // act
      final result = await repository.getLogsForSkill('skill_1');

      // assert
      expect(result.length, 1);
      expect(result.first.skill, tSkill);
      expect(result.first.skill.name, 'Pizza Cooking');

      verify(() => mockSkillRepository.getSkill('skill_1')).called(1);
      verify(
        () => mockDataSource.getLogsForSkill('skill_1', 'user_1'),
      ).called(1);
    });
  });
}
