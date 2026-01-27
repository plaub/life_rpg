import '../entities/skill.dart';
import '../entities/skill_category.dart';
import '../entities/skill_log.dart';
import '../entities/skill_progress.dart';

abstract class SkillRepository {
  /// Stream of skills for a specific user.
  Stream<List<Skill>> getSkills(String userId);

  /// Get a single skill by ID.
  Future<Skill?> getSkill(String skillId);

  /// Create or update a skill.
  Future<void> saveSkill(Skill skill);

  /// Delete a skill (and potentially its progress/logs).
  Future<void> deleteSkill(String skillId);

  /// Stream of progress for a specific skill.
  Stream<SkillProgress?> getSkillProgress(String skillId, String userId);

  /// Stream of skill categories for a specific user.
  Stream<List<SkillCategory>> getCategories(String userId);

  /// Create or update a skill category.
  Future<void> saveCategory(SkillCategory category);

  /// Create a new log entry.
  Future<void> createLog(SkillLog log);

  /// Get logs for a skill.
  Future<List<SkillLog>> getLogs(String skillId, String userId);

  /// Get a single log by ID.
  Future<SkillLog?> getLog(String logId, String skillId);

  /// Update a log entry.
  Future<void> updateLog(SkillLog log);

  /// Delete a log entry.
  Future<void> deleteLog(String logId);

  /// Get all logs for a user (across all skills).
  Future<List<SkillLog>> getAllLogs(String userId);

  /// Stream of all logs for a user.
  Stream<List<SkillLog>> getAllLogsStream(String userId);
}
