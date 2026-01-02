import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../skill/domain/entities/skill_category.dart';

class SkillRadarChart extends StatelessWidget {
  final Map<String, int> categoryValues;
  final List<SkillCategory> categories;

  const SkillRadarChart({
    super.key,
    required this.categoryValues,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 2. Prepare counts
    // categoryValues is passed from parent

    // Fallback if < 3 categories (RadarChart requires >= 3)
    if (categories.length < 3) {
      final maxVal = categoryValues.values.fold(
        0,
        (max, count) => count > max ? count : max,
      );
      final effectiveMax = maxVal > 0 ? maxVal : 1;

      return Column(
        children: categories.map((c) {
          final count = categoryValues[c.id] ?? 0;
          final progress = count / effectiveMax;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(c.name, style: theme.textTheme.bodyMedium),
                    Text('$count XP', style: theme.textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    final dataSets = <RadarDataSet>[
      RadarDataSet(
        fillColor: theme.colorScheme.primary.withValues(alpha: 0.2),
        borderColor: theme.colorScheme.primary,
        entryRadius: 2,
        dataEntries: categories.map((c) {
          final count = categoryValues[c.id] ?? 0;
          return RadarEntry(value: count.toDouble());
        }).toList(),
        borderWidth: 2,
      ),
    ];

    return AspectRatio(
      aspectRatio: 1.3,
      child: RadarChart(
        RadarChartData(
          radarTouchData: RadarTouchData(enabled: true),

          dataSets: dataSets,
          radarBackgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          radarBorderData: const BorderSide(color: Colors.transparent),
          titlePositionPercentageOffset: 0.2,
          titleTextStyle: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface,
          ),

          // Ticks
          tickCount: 3,
          ticksTextStyle: const TextStyle(
            color: Colors.transparent,
          ), // Hide numbers on web if too cluttered
          tickBorderData: BorderSide(color: theme.colorScheme.outlineVariant),
          gridBorderData: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),

          getTitle: (index, angle) {
            if (index >= categories.length) {
              return const RadarChartTitle(text: '');
            }
            final category = categories[index];
            // Use icon or short name
            return RadarChartTitle(text: category.name);
          },
        ),
      ),
    );
  }
}
