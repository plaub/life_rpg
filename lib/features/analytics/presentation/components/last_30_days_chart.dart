import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../skill/domain/entities/skill_log.dart';

class Last30DaysChart extends StatelessWidget {
  final List<SkillLog> logs;

  const Last30DaysChart({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    // Normalize today to start of day for consistent comparison
    final today = DateTime(now.year, now.month, now.day);

    // 1. Prepare Data for last 30 days
    final Map<int, int> dailyXp = {};

    // Initialize last 30 days with 0
    for (int i = 0; i < 30; i++) {
      dailyXp[i] = 0;
    }

    // Aggregate logs
    for (var log in logs) {
      final logDate = DateTime(log.date.year, log.date.month, log.date.day);
      final difference = today.difference(logDate).inDays;

      if (difference >= 0 && difference < 30) {
        // Map difference (0 = today, 29 = 30 days ago) to chart index
        // Let's make index 0 = 30 days ago, index 29 = today for the chart
        final index = 29 - difference;
        dailyXp[index] = (dailyXp[index] ?? 0) + log.xpEarned;
      }
    }

    final barGroups = <BarChartGroupData>[];
    double maxY = 0;

    for (int i = 0; i < 30; i++) {
      final val = dailyXp[i]!.toDouble();
      if (val > maxY) maxY = val;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: val,
              color: theme.colorScheme.primary,
              width: 8,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    // Add some buffer to maxY
    maxY = maxY > 0 ? maxY * 1.1 : 10;

    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                // Calculate date from index
                // index 29 = today, index 0 = today - 29 days
                final dayOffset = 29 - group.x.toInt();
                final date = today.subtract(Duration(days: dayOffset));
                final dateStr = DateFormat.MMMd().format(date);

                return BarTooltipItem(
                  '$dateStr\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${rod.toY.toInt()} XP',
                      style: TextStyle(
                        color: theme.colorScheme.primaryContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  // Show labels for every 5 days or so to avoid clutter
                  if (index % 5 != 4) return const SizedBox.shrink();

                  final dayOffset = 29 - index;
                  final date = today.subtract(Duration(days: dayOffset));

                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat.d().format(date),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ), // Hide left axis numbers for cleaner look
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
        ),
      ),
    );
  }
}
