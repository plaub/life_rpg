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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Fallback values if progress is not yet loaded
    final level = progress?.level ?? 1;
    final xpCurrent = progress?.xpCurrent ?? 0;
    final xpTotal = progress?.xpTotal ?? 50; // Default next level

    return Card(
      elevation: 0, // Flat style suitable for modern lists
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            skill.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
    );
  }
}
