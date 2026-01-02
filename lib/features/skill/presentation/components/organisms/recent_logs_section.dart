import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_rpg/core/i18n/app_localizations.dart';
import 'package:life_rpg/core/router/route_names.dart';
import 'package:life_rpg/features/skill/domain/logic/xp_calculator.dart';
import 'package:life_rpg/features/skill/presentation/providers/skill_providers.dart';
import 'package:life_rpg/features/skill/presentation/components/atoms/date_label.dart';

class RecentLogsSection extends ConsumerWidget {
  final String skillId;

  const RecentLogsSection({super.key, required this.skillId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(skillLogsProvider(skillId));
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return logsAsync.when(
      data: (logs) {
        if (logs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                l10n.noLogsYet,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }

        // Show last 5 logs
        final recentLogs = logs.take(5).toList();

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: recentLogs.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final log = recentLogs[index];
            IconData typeIcon;
            String typeLabel;
            switch (log.sessionType) {
              case SkillSessionType.learn:
                typeIcon = Icons.school;
                typeLabel = l10n.sessionTypeLearn;
                break;
              case SkillSessionType.apply:
                typeIcon = Icons.build;
                typeLabel = l10n.sessionTypeApply;
                break;
              case SkillSessionType.both:
                typeIcon = Icons.auto_awesome;
                typeLabel = l10n.sessionTypeBoth;
                break;
            }

            return ListTile(
              onTap: () {
                context.push(
                  RouteNames.editLog
                      .replaceFirst(':id', skillId)
                      .replaceFirst(':logId', log.id),
                );
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  '+${log.xpEarned}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              title: Text(
                log.note != null && log.note!.isNotEmpty
                    ? log.note!
                    : l10n.practiceSession,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Row(
                children: [
                  DateLabel(date: log.date, showTime: true),
                  if (log.durationMinutes != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '• ${l10n.durationMinutesLabel(log.durationMinutes!)}',
                    ),
                  ],
                ],
              ),
              trailing: Tooltip(
                message: typeLabel,
                child: Icon(
                  typeIcon,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                  semanticLabel: typeLabel,
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) =>
          Center(child: Text('${l10n.errorLoadingCategories}: $err')),
    );
  }
}
