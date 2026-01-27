import 'package:flutter/material.dart';
import '../../../domain/entities/skill.dart';
import '../../../domain/entities/skill_progress.dart';
import '../atoms/category_chip.dart';
import '../atoms/level_badge.dart';
import '../atoms/skill_icon.dart';
import '../atoms/xp_label.dart';
import 'level_progress_bar.dart';

class SkillHeader extends StatelessWidget {
  final Skill skill;
  final SkillProgress? progress;

  const SkillHeader({super.key, required this.skill, this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final level = progress?.level ?? 1;

    return Container(
      padding: const EdgeInsets.all(24.0),
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SkillIcon(
                icon: skill.icon,
                colorHex: skill.category.color,
                size: 72,
                fontSize: 36,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryChip(category: skill.category),
                    const SizedBox(height: 8),
                    Text(
                      skill.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          LevelProgressBar(
            currentXp: progress?.xpCurrent ?? 0,
            requiredXp: progress?.xpTotal ?? 50,
            height: 12,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              XPLabel(
                current: progress?.xpCurrent ?? 0,
                total: progress?.xpTotal ?? 50,
              ),
              LevelBadge(level: level, compact: true),
            ],
          ),
        ],
      ),
    );
  }
}
