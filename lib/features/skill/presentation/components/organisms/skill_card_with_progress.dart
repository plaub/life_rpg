import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_rpg/core/router/route_names.dart';

import 'package:life_rpg/features/skill/domain/entities/skill.dart';
import 'package:life_rpg/features/skill/presentation/providers/skill_providers.dart';
import 'package:life_rpg/features/skill/presentation/components/molecules/skill_card.dart';

class SkillCardWithProgress extends ConsumerWidget {
  final Skill skill;

  const SkillCardWithProgress({
    super.key,
    required this.skill,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(skillProgressProvider(skill.id));
    
    // We can decide how to handle loading/error.
    // For a list item, usually we might show a skeleton or just default values.
    // SkillCard handles null progress by showing defaults (Lvl 1, 0 XP).
    // So we can just pass content if value exists, or null if loading/error.
    
    final progress = progressAsync.whenOrNull(data: (d) => d);

    return SkillCard(
      skill: skill,
      progress: progress,
      onTap: () {
        context.go(RouteNames.skillDetail.replaceFirst(':id', skill.id));
      },
      // You could also add onLongPress to show QuickLog directly?
    );
  }
}
