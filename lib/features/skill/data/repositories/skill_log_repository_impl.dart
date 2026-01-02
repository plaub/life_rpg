import '../../domain/entities/skill.dart';
import '../../domain/entities/skill_log.dart';
import '../../domain/repositories/skill_log_repository.dart';
import '../../domain/repositories/skill_repository.dart';
import '../datasources/skill_remote_datasource.dart';
import '../models/skill_log_model.dart';

class SkillLogRepositoryImpl implements SkillLogRepository {
  final SkillRemoteDataSource _remoteDataSource;
  final SkillRepository _skillRepository;

  SkillLogRepositoryImpl(this._remoteDataSource, this._skillRepository);

  @override
  Future<List<SkillLog>> getLogsForSkill(String skillId, {int? limit}) async {
    final skill = await _skillRepository.getSkill(skillId);
    if (skill == null) return [];

    final models = await _remoteDataSource.getLogsForSkill(
      skillId,
      skill.userId,
      limit: limit,
    );

    return models.map((m) => m.toEntity(skill)).toList();
  }

  @override
  Future<List<SkillLog>> getLogsForUser(String userId, {int? limit}) async {
    final models = await _remoteDataSource.getLogsForUser(userId, limit: limit);
    final logs = <SkillLog>[];

    // This is potentially slow (N queries for N logs).
    // Optimization: Cache skills in a map during this operation.
    final skillCache = <String, Skill>{};

    for (final model in models) {
      if (!skillCache.containsKey(model.skillId)) {
        final skill = await _skillRepository.getSkill(model.skillId);
        if (skill != null) {
          skillCache[model.skillId] = skill;
        }
      }

      final skill = skillCache[model.skillId];
      if (skill != null) {
        logs.add(model.toEntity(skill));
      }
    }

    return logs;
  }

  @override
  Future<void> createLog(SkillLog log) async {
    final model = SkillLogModel.fromEntity(log);
    await _remoteDataSource.createLog(model);
  }

  @override
  Future<void> deleteLog(String logId) async {
    await _remoteDataSource.deleteLog(logId);
  }
}
