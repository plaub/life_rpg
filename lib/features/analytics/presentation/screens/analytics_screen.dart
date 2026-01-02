import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../skill/presentation/providers/skill_providers.dart';
import '../components/skill_radar_chart.dart';
import '../components/last_30_days_chart.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final skillsAsync = ref.watch(skillsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final logsAsync = ref.watch(allLogsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.analyticsTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                return skillsAsync.when(
                  data: (skills) {
                    return Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            label: localizations.analyticsTotalXp,
                            value: totalXp.toString(),
                            icon: Icons.bolt,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _MetricCard(
                            label: localizations.analyticsSkills,
                            value: skills.length.toString(),
                            icon: Icons.star,
                            color: Colors.blue,
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
            Text(
              localizations.analyticsDistribution,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
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

            // 3. Last 30 Days Chart
            Text(
              localizations.analyticsLast30Days,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
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
                return Last30DaysChart(logs: logs);
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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
