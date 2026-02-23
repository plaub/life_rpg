import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../skill/presentation/providers/skill_providers.dart';
import '../components/skill_radar_chart.dart';
import '../components/active_days_chart.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final skillsAsync = ref.watch(skillsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final logsAsync = ref.watch(allLogsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.analyticsTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Overview Cards
            logsAsync.when(
              data: (logs) {
                final totalXp = logs.fold<int>(
                  0,
                  (sum, log) => sum + log.xpEarned,
                );
                final totalMinutes = logs.fold<int>(
                  0,
                  (sum, log) => sum + (log.durationMinutes ?? 0),
                );
                final totalHours = totalMinutes ~/ 60;
                final remainingMin = totalMinutes % 60;
                final timeStr = totalHours > 0
                    ? '${totalHours}h ${remainingMin}m'
                    : '${totalMinutes}m';

                return skillsAsync.when(
                  data: (skills) {
                    return Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            label: localizations.analyticsTotalXp,
                            value: totalXp.toString(),
                            icon: Icons.bolt_rounded,
                            color: AppColors.xpGold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricCard(
                            label: localizations.analyticsSkills,
                            value: skills.length.toString(),
                            icon: Icons.star_rounded,
                            color: AppColors.levelPurple,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricCard(
                            label: localizations.analyticsTotalTime,
                            value: timeStr,
                            icon: Icons.timer_rounded,
                            color: AppColors.successGreen,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => const SizedBox.shrink(),
                );
              },
              loading: () => const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) =>
                  Text('${localizations.analyticsError}: $err'),
            ),

            const SizedBox(height: 32),

            // 2. Radar Chart
            _SectionHeader(title: localizations.analyticsDistribution),
            const SizedBox(height: 16),
            skillsAsync.when(
              data: (skills) {
                return categoriesAsync.when(
                  data: (categories) {
                    return logsAsync.when(
                      data: (logs) {
                        if (skills.isEmpty || categories.isEmpty) {
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: Text(localizations.analyticsNotEnoughData),
                            ),
                          );
                        }

                        // Calculate XP per category
                        final Map<String, int> categoryXp = {
                          for (var c in categories) c.id: 0,
                        };

                        for (var log in logs) {
                          final categoryId = log.skill.category.id;
                          if (categoryXp.containsKey(categoryId)) {
                            categoryXp[categoryId] =
                                categoryXp[categoryId]! + log.xpEarned;
                          }
                        }

                        return SizedBox(
                          height: 300,
                          child: SkillRadarChart(
                            categoryValues: categoryXp,
                            categories: categories,
                          ),
                        );
                      },
                      loading: () => const SizedBox(
                        height: 300,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (_, _) => const SizedBox.shrink(),
                    );
                  },
                  loading: () => const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, _) => const SizedBox.shrink(),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 32),

            // 3. Active Days Chart
            _SectionHeader(title: localizations.analyticsActiveDays),
            const SizedBox(height: 16),
            logsAsync.when(
              data: (logs) {
                if (logs.isEmpty) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(localizations.analyticsNoActivity),
                    ),
                  );
                }
                return ActiveDaysChart(logs: logs);
              },
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

/// Section header with decorative accent line
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? color.withValues(alpha: 0.2)
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.15),
                  color.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
