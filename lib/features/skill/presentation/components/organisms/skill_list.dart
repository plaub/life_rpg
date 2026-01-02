import 'package:flutter/material.dart';
import '../../../../../core/i18n/app_localizations.dart';
import '../../../domain/entities/skill.dart';
import 'skill_card_with_progress.dart';

class SkillList extends StatelessWidget {
  final List<Skill> skills;

  const SkillList({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      final l10n = AppLocalizations.of(context);
      return Center(
        child: Text(
          l10n.noSkillsHere,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        return SkillCardWithProgress(skill: skills[index]);
      },
    );
  }
}
