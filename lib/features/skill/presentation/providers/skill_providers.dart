import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_rpg/features/skill/domain/entities/skill.dart';
import 'package:life_rpg/features/skill/domain/entities/skill_log.dart';
import 'package:life_rpg/features/skill/domain/entities/skill_category.dart';
import 'package:life_rpg/features/skill/domain/entities/skill_progress.dart';
import 'package:life_rpg/features/skill/domain/repositories/skill_repository.dart';
import 'package:life_rpg/features/skill/data/datasources/skill_remote_datasource.dart';
import 'package:life_rpg/features/skill/data/repositories/skill_repository_impl.dart';
import 'package:life_rpg/features/auth/presentation/providers/auth_providers.dart';

// Repository Provider
final skillRepositoryProvider = Provider<SkillRepository>((ref) {
  // We assume RemoteDataSource is stateless or self-contained.
  // Ideally, DataSource might need dependencies too.
  // For now:
  final dataSource = SkillRemoteDataSourceImpl();
  return SkillRepositoryImpl(dataSource);
});

// Stream of all Skills for the current user
final skillsProvider = StreamProvider.autoDispose<List<Skill>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();

  final repository = ref.watch(skillRepositoryProvider);
  return repository.getSkills(user.id);
});

// -- FILTERING --

// State for the currently selected category filter (null = all)
class CategoryFilter extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? id) => state = id;
}

final categoryFilterProvider = NotifierProvider<CategoryFilter, String?>(
  CategoryFilter.new,
);

// Derived provider for filtered skills
final filteredSkillsProvider = Provider.autoDispose<AsyncValue<List<Skill>>>((
  ref,
) {
  final skillsAsync = ref.watch(skillsProvider);
  final filterId = ref.watch(categoryFilterProvider);

  return skillsAsync.whenData((skills) {
    if (filterId == null) return skills;
    return skills.where((s) => s.category.id == filterId).toList();
  });
});

// -- END FILTERING --

// Stream of progress for a specific skill
final skillProgressProvider = StreamProvider.family
    .autoDispose<SkillProgress?, String>((ref, skillId) {
      final user = ref.watch(currentUserProvider);
      if (user == null) return const Stream.empty();

      final repository = ref.watch(skillRepositoryProvider);
      return repository.getSkillProgress(skillId, user.id);
    });

// Helper to get a specific skill by ID (if needed)
final skillDetailProvider = FutureProvider.family.autoDispose<Skill?, String>((
  ref,
  skillId,
) async {
  final repository = ref.watch(skillRepositoryProvider);
  return repository.getSkill(skillId);
});

// Stream of categories
final categoriesProvider = StreamProvider.autoDispose<List<SkillCategory>>((
  ref,
) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();

  final repository = ref.watch(skillRepositoryProvider);
  return repository.getCategories(user.id);
});

// Logs for a skill
final skillLogsProvider = FutureProvider.family
    .autoDispose<List<SkillLog>, String>((ref, skillId) async {
      final user = ref.watch(currentUserProvider);
      if (user == null) return [];

      final repository = ref.watch(skillRepositoryProvider);
      return repository.getLogs(skillId, user.id);
    });

// Single Log
final skillLogProvider = FutureProvider.family
    .autoDispose<SkillLog?, ({String skillId, String logId})>((ref, arg) async {
      final repository = ref.watch(skillRepositoryProvider);
      return repository.getLog(arg.logId, arg.skillId);
    });

// All Logs for the current user
final allLogsProvider = FutureProvider.autoDispose<List<SkillLog>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  final repository = ref.watch(skillRepositoryProvider);
  return repository.getAllLogs(user.id);
});

// Stream of all logs for the current user
final allLogsStreamProvider = StreamProvider.autoDispose<List<SkillLog>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();

  final repository = ref.watch(skillRepositoryProvider);
  return repository.getAllLogsStream(user.id);
});

// All Skill Progress map (id -> Progress)
final allSkillProgressProvider =
    Provider.autoDispose<AsyncValue<Map<String, int>>>((ref) {
      final logsAsync = ref.watch(allLogsStreamProvider);

      return logsAsync.whenData((logs) {
        // Group logs by skill
        final groupedLogs = <String, List<SkillLog>>{};
        final skillNames = <String, String>{};

        for (final log in logs) {
          groupedLogs.putIfAbsent(log.skill.id, () => []).add(log);
          skillNames[log.skill.id] = log.skill.name;
        }

        // Calculate level for each skill
        final levels = <String, int>{};
        for (final entry in groupedLogs.entries) {
          final progress = SkillProgress.fromLogs(
            id: 'calculated',
            userId: entry.value.first.userId,
            skill: entry.value.first.skill,
            logs: entry.value,
          );
          levels[entry.key] = progress.level;
        }
        return levels;
      });
    });

// Helper provider for skill names
final skillNamesProvider =
    Provider.autoDispose<AsyncValue<Map<String, String>>>((ref) {
      final logsAsync = ref.watch(allLogsStreamProvider);
      return logsAsync.whenData((logs) {
        final names = <String, String>{};
        for (final log in logs) {
          names[log.skill.id] = log.skill.name;
        }
        return names;
      });
    });
