import 'package:flutter/material.dart';
import '../../../domain/entities/skill.dart';
import '../../../domain/entities/skill_progress.dart';
import '../../components/atoms/level_badge.dart';
import '../../components/atoms/skill_icon.dart';
import '../../components/atoms/xp_label.dart';
import '../../components/molecules/level_progress_bar.dart';
import '../atoms/category_chip.dart';

class SkillCard extends StatelessWidget {
  final Skill skill;
  final SkillProgress? progress;
  final VoidCallback? onTap;

  const SkillCard({super.key, required this.skill, this.progress, this.onTap});

  Color _parseColor(String hexCode) {
    try {
      final hex = hexCode.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final categoryColor = _parseColor(skill.category.color);

    // Fallback values if progress is not yet loaded
    final level = progress?.level ?? 1;
    final xpCurrent = progress?.xpCurrent ?? 0;
    final xpTotal = progress?.xpTotal ?? 50; // Default next level

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? categoryColor.withValues(alpha: 0.15)
              : theme.colorScheme.outlineVariant,
          width: 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: categoryColor.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Icon
                SkillIcon(
                  icon: skill.icon,
                  colorHex: skill.category.color,
                  size: 56,
                  fontSize: 28,
                ),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        skill.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      CategoryChip(category: skill.category),
                      const SizedBox(height: 8),

                      // Progress Bar
                      LevelProgressBar(
                        currentXp: xpCurrent,
                        requiredXp: xpTotal,
                        height: 6,
                      ),
                      const SizedBox(height: 4),

                      // Stats Labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          XPLabel(current: xpCurrent, total: xpTotal),
                          LevelBadge(level: level, compact: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
