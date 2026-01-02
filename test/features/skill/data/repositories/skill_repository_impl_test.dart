import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:life_rpg/features/skill/data/datasources/skill_remote_datasource.dart';
import 'package:life_rpg/features/skill/data/models/skill_model.dart';
import 'package:life_rpg/features/skill/data/models/skill_category_model.dart';
import 'package:life_rpg/features/skill/data/repositories/skill_repository_impl.dart';

class MockSkillRemoteDataSource extends Mock implements SkillRemoteDataSource {}

// ignore: subtype_of_sealed_class
class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class FakeDocumentReference extends Fake
    implements DocumentReference<Map<String, dynamic>> {}

void main() {
  late SkillRepositoryImpl repository;
  late MockSkillRemoteDataSource mockDataSource;
  late MockDocumentReference mockCategoryRef;
  late SkillModel tSkillModel;
  late SkillCategoryModel tCategoryModel;

  setUpAll(() {
    registerFallbackValue(FakeDocumentReference());
  });

  setUp(() {
    mockDataSource = MockSkillRemoteDataSource();
    mockCategoryRef = MockDocumentReference();
    repository = SkillRepositoryImpl(mockDataSource);

    when(() => mockCategoryRef.id).thenReturn('cat_1');

    tSkillModel = SkillModel(
      id: 'skill_1',
      userId: 'user_1',
      name: 'Pizza Cooking',
      categoryRef: mockCategoryRef,
      icon: '🍕',
      isActive: true,
      createdAt: DateTime(2025, 1, 1),
      updatedAt: DateTime(2025, 1, 1),
    );

    tCategoryModel = SkillCategoryModel(
      id: 'cat_1',
      userId: 'user_1',
      key: 'cooking',
      name: 'Cooking',
      icon: '🍳',
      color: 'FF5733',
    );
  });

  group('SkillRepositoryImpl', () {
    test('getSkill should return a joined Skill entity', () async {
      // arrange
      when(
        () => mockDataSource.getSkill(any()),
      ).thenAnswer((_) async => tSkillModel);
      when(
        () => mockDataSource.getCategory(any()),
      ).thenAnswer((_) async => tCategoryModel);

      // act
      final result = await repository.getSkill('skill_1');

      // assert
      expect(result, isNotNull);
      expect(result!.id, 'skill_1');
      expect(result.category.id, 'cat_1');
      expect(result.category.name, 'Cooking');

      verify(() => mockDataSource.getSkill('skill_1')).called(1);
      verify(() => mockDataSource.getCategory(mockCategoryRef)).called(1);
    });

    test(
      'getSkill should return Skill with fallback category if category fetched is null',
      () async {
        // arrange
        when(
          () => mockDataSource.getSkill(any()),
        ).thenAnswer((_) async => tSkillModel);
        when(
          () => mockDataSource.getCategory(any()),
        ).thenAnswer((_) async => null);

        // act
        final result = await repository.getSkill('skill_1');

        // assert
        expect(result, isNotNull);
        expect(result!.category.id, 'unknown');
      },
    );
  });
}
