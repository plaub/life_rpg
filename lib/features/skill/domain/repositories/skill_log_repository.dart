import '../entities/skill_log.dart';

abstract class SkillLogRepository {
  /// Get logs for a specific skill.
  /// [limit] can limit the number of logs returned.
  Future<List<SkillLog>> getLogsForSkill(String skillId, {int? limit});

  /// Get logs for a user across all skills (e.g. for recent activity).
  Future<List<SkillLog>> getLogsForUser(String userId, {int? limit});

  /// Create a new log entry.
  Future<void> createLog(SkillLog log);

  /// Delete a log entry
  Future<void> deleteLog(String logId);
}
