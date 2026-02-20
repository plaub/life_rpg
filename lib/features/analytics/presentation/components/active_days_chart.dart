import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../skill/domain/entities/skill_log.dart';

/// A bar chart that shows only days where at least one session was logged.
/// No empty-day bars — no daily pressure, just cumulative progress over time.
class ActiveDaysChart extends StatelessWidget {
  final List<SkillLog> logs;

  const ActiveDaysChart({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Aggregate XP per unique calendar day
    final Map<DateTime, int> dailyXp = {};
    for (final log in logs) {
      final day = DateTime(log.date.year, log.date.month, log.date.day);
      dailyXp[day] = (dailyXp[day] ?? 0) + log.xpEarned;
    }

    // Sort days chronologically
    final sortedDays = dailyXp.keys.toList()..sort();

    if (sortedDays.isEmpty) return const SizedBox.shrink();

    double maxY = 0;
    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < sortedDays.length; i++) {
      final xp = dailyXp[sortedDays[i]]!.toDouble();
      if (xp > maxY) maxY = xp;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: xp,
              color: colorScheme.primary,
              width: sortedDays.length <= 10 ? 20 : 12,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(6),
              ),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxY * 1.15,
                color: colorScheme.surfaceContainerHighest,
              ),
            ),
          ],
        ),
      );
    }

    maxY = maxY > 0 ? maxY * 1.15 : 10;

    // Decide label interval: show all if <= 10, otherwise every Nth
    final labelInterval = sortedDays.length <= 10
        ? 1
        : (sortedDays.length / 6).ceil();

    final chartWidth = sortedDays.length <= 10
        ? null // fill width
        : (sortedDays.length * 40.0).clamp(300.0, double.infinity);

    Widget chart = BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final day = sortedDays[group.x.toInt()];
              final dateStr = DateFormat('d. MMM').format(day);
              return BarTooltipItem(
                '$dateStr\n',
                TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                children: [
                  TextSpan(
                    text: '${rod.toY.toInt()} XP',
                    style: TextStyle(
                      color: colorScheme.primaryContainer,
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
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index % labelInterval != 0) return const SizedBox.shrink();
                final day = sortedDays[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    DateFormat('d. MMM').format(day),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
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
    );

    if (chartWidth != null) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(width: chartWidth, height: 200, child: chart),
      );
    }

    return SizedBox(height: 200, child: chart);
  }
}
