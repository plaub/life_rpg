import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:life_rpg/core/i18n/app_localizations.dart';
import 'package:life_rpg/core/router/route_names.dart';
import 'package:life_rpg/features/skill/presentation/providers/skill_providers.dart';
import 'package:life_rpg/features/skill/presentation/components/molecules/skill_header.dart';
import 'package:life_rpg/features/skill/presentation/components/organisms/recent_logs_section.dart';
import 'package:life_rpg/features/skill/presentation/dialogs/quick_log_bottom_sheet.dart';

class SkillDetailScreen extends ConsumerWidget {
  final String skillId;

  const SkillDetailScreen({
    super.key,
    required this.skillId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final skillAsync = ref.watch(skillDetailProvider(skillId));
    final progressAsync = ref.watch(skillProgressProvider(skillId));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // Title in header
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push(RouteNames.editSkill.replaceFirst(':id', skillId));
            },
          ),
        ],
      ),
      body: skillAsync.when(
        data: (skill) {
          if (skill == null) return Center(child: Text(l10n.skillNotFound));

          final progress = progressAsync.whenOrNull(data: (d) => d);

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              SkillHeader(skill: skill, progress: progress),
              
              const SizedBox(height: 24),
              
              // Stats / Description
              if (skill.description != null && skill.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    skill.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 32),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  l10n.logsTab, // "Logs"
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Recent Logs
              RecentLogsSection(skillId: skillId),

              const SizedBox(height: 80), // Fab space
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('${l10n.error}: $err')),
      ),
      floatingActionButton: skillAsync.whenOrNull(data: (d) => d) != null 
        ? FloatingActionButton.extended(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => QuickLogBottomSheet(skill: skillAsync.value!),
              );
            },
            icon: const Icon(Icons.timer),
            label: Text(l10n.quickLogButton),
          )
        : null,
    );
  }
}
