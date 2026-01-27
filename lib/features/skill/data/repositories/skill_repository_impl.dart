import '../../domain/entities/skill.dart';
import '../../domain/entities/skill_progress.dart';
import '../../domain/entities/skill_category.dart';
import '../../domain/entities/skill_log.dart';
import '../../domain/repositories/skill_repository.dart';
import '../datasources/skill_remote_datasource.dart';
import '../models/skill_model.dart';
import '../models/skill_category_model.dart';
import '../models/skill_log_model.dart';

class SkillRepositoryImpl implements SkillRepository {
  final SkillRemoteDataSource _remoteDataSource;

  SkillRepositoryImpl(this._remoteDataSource);

  @override
  Stream<List<Skill>> getSkills(String userId) {
    return _remoteDataSource.getSkills(userId).asyncMap((models) async {
      final skills = <Skill>[];
      for (final model in models) {
        // Resolve category
        // TODO: Caching strategy needed if N is large.
        final cateogryModel = await _remoteDataSource.getCategory(
          model.categoryRef,
        );
        // Fallback for deleted categories?
        final category =
            cateogryModel ??
            // Placeholder if missing
            const SkillCategory(
              id: 'unknown',
              userId: 'unknown',
              key: 'unknown',
              name: 'Unknown',
              icon: '',
              color: '000000',
            );

        skills.add(model.toEntity(category));
      }
      return skills;
    });
  }

  @override
  Future<Skill?> getSkill(String skillId) async {
    final model = await _remoteDataSource.getSkill(skillId);
    if (model == null) return null;

    final categoryModel = await _remoteDataSource.getCategory(
      model.categoryRef,
    );
    final category =
        categoryModel ??
        const SkillCategory(
          id: 'unknown',
          userId: 'unknown',
          key: 'unknown',
          name: 'Unknown',
          icon: '',
          color: '000000',
        );

    return model.toEntity(category);
  }

  @override
  Future<void> saveSkill(Skill skill) async {
    final categoryRef = _remoteDataSource.createCategoryRef(skill.category.id);

    final model = SkillModel(
      id: skill.id,
      userId: skill.userId,
      name: skill.name,
      description: skill.description,
      categoryRef: categoryRef,
      icon: skill.icon,
      isActive: skill.isActive,
      createdAt: skill.createdAt,
      updatedAt: skill.updatedAt,
    );

    await _remoteDataSource.saveSkill(model);
  }

  @override
  Future<void> deleteSkill(String skillId) async {
    await _remoteDataSource.deleteSkill(skillId);
  }

  @override
  Stream<SkillProgress?> getSkillProgress(String skillId, String userId) {
    return _remoteDataSource.getLogsForSkillStream(skillId, userId).asyncMap((
      logModels,
    ) async {
      final skill = await getSkill(skillId);
      if (skill == null) return null;

      final logs = logModels.map((m) => m.toEntity(skill)).toList();

      return SkillProgress.fromLogs(
        id: 'calculated',
        userId: userId,
        skill: skill,
        logs: logs,
      );
    });
  }

  @override
  Future<void> saveCategory(SkillCategory category) async {
    final model = SkillCategoryModel.fromEntity(category);
    await _remoteDataSource.saveCategory(model);
  }

  @override
  Stream<List<SkillCategory>> getCategories(String userId) {
    return _remoteDataSource.getCategories(userId).map((models) {
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<void> createLog(SkillLog log) async {
    final model = SkillLogModel.fromEntity(log);
    await _remoteDataSource.createLog(model);
  }

  @override
  Future<List<SkillLog>> getLogs(String skillId, String userId) async {
    final skill = await getSkill(skillId);
    if (skill == null) return [];

    final models = await _remoteDataSource.getLogsForSkill(skillId, userId);
    return models.map((model) => model.toEntity(skill)).toList();
  }

  @override
  Future<SkillLog?> getLog(String logId, String skillId) async {
    final skill = await getSkill(skillId);
    if (skill == null) return null;

    final model = await _remoteDataSource.getLog(logId);
    if (model == null) return null;

    return model.toEntity(skill);
  }

  @override
  Future<void> updateLog(SkillLog log) async {
    final model = SkillLogModel.fromEntity(log);
    await _remoteDataSource.createLog(model); // set() works for both
  }

  @override
  Future<void> deleteLog(String logId) async {
    await _remoteDataSource.deleteLog(logId);
  }

  @override
  Future<List<SkillLog>> getAllLogs(String userId) async {
    final logModels = await _remoteDataSource.getLogsForUser(userId);

    // Identify unique skills involved to minimize fetches
    final skillIds = logModels.map((m) => m.skillId).toSet();
    final skillMap = <String, Skill>{};

    for (final skillId in skillIds) {
      final skill = await getSkill(skillId);
      if (skill != null) {
        skillMap[skillId] = skill;
      }
    }

    // Map models to entities
    final logs = <SkillLog>[];
    for (final model in logModels) {
      final skill = skillMap[model.skillId];
      if (skill != null) {
        logs.add(model.toEntity(skill));
      }
    }
    return logs;
  }

  @override
  Stream<List<SkillLog>> getAllLogsStream(String userId) {
    return _remoteDataSource.getLogsForUserStream(userId).asyncMap((
      logModels,
    ) async {
      final skillIds = logModels.map((m) => m.skillId).toSet();
      final skillMap = <String, Skill>{};

      for (final skillId in skillIds) {
        final skill = await getSkill(skillId);
        if (skill != null) {
          skillMap[skillId] = skill;
        }
      }

      final logs = <SkillLog>[];
      for (final model in logModels) {
        final skill = skillMap[model.skillId];
        if (skill != null) {
          logs.add(model.toEntity(skill));
        }
      }
      return logs;
    });
  }
}
