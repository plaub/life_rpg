import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:life_rpg/core/i18n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/skill.dart';
import '../../domain/entities/skill_log.dart';
import '../../domain/logic/xp_calculator.dart';
import '../../presentation/providers/skill_providers.dart';
import '../components/atoms/date_label.dart';

class QuickLogBottomSheet extends ConsumerStatefulWidget {
  final Skill skill;

  const QuickLogBottomSheet({super.key, required this.skill});

  @override
  ConsumerState<QuickLogBottomSheet> createState() =>
      _QuickLogBottomSheetState();
}

class _QuickLogBottomSheetState extends ConsumerState<QuickLogBottomSheet> {
  SkillSessionType _sessionType = SkillSessionType.apply;
  final Set<SkillSessionTag> _tags = {};
  double _duration = 30; // minutes
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  int _calculateXP() {
    return XPCalculator.calculateXP(
      durationMinutes: _duration.round(),
      sessionType: _sessionType,
      tags: _tags.toList(),
    );
  }

  Future<void> _saveLog() async {
    setState(() => _isSaving = true);
    final user = ref.read(currentUserProvider);
    if (user == null) {
      if (mounted) context.pop();
      return;
    }

    try {
      final now = DateTime.now();
      final xpGained = _calculateXP();

      // 1. Create Log
      final log = SkillLog(
        id: const Uuid().v4(),
        userId: user.id,
        skill: widget.skill,
        date: _selectedDate,
        durationMinutes: _duration.round(),
        sessionType: _sessionType,
        tags: _tags.toList(),
        xpEarned: xpGained,
        note: _noteController.text.trim(),
        createdAt: now,
      );

      final repo = ref.read(skillRepositoryProvider);
      await repo.createLog(log);

      // Refresh providers
      ref.invalidate(skillLogsProvider(widget.skill.id));

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).xpGainedMessage(xpGained),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _toggleTag(SkillSessionTag tag) {
    setState(() {
      if (_tags.contains(tag)) {
        _tags.remove(tag);
      } else {
        _tags.add(tag);
      }
    });
  }

  String _getSessionTypeLabel(AppLocalizations l10n, SkillSessionType type) {
    switch (type) {
      case SkillSessionType.learn:
        return l10n.sessionTypeLearn;
      case SkillSessionType.apply:
        return l10n.sessionTypeApply;
      case SkillSessionType.both:
        return l10n.sessionTypeBoth;
    }
  }

  String _getTagLabel(AppLocalizations l10n, SkillSessionTag tag) {
    switch (tag) {
      case SkillSessionTag.repeat:
        return l10n.tagRepeat;
      case SkillSessionTag.review:
        return l10n.tagReview;
      case SkillSessionTag.teach:
        return l10n.tagTeach;
      case SkillSessionTag.experiment:
        return l10n.tagExperiment;
      case SkillSessionTag.challenge:
        return l10n.tagChallenge;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final xpPreview = _calculateXP();

    return Container(
      padding: const EdgeInsets.all(
        24,
      ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.skill.name,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Center(
            child: InkWell(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null && mounted) {
                  if (!context.mounted) return;
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_selectedDate),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _selectedDate = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    DateLabel(date: _selectedDate, showTime: true),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Session Type
          Text(l10n.sessionTypeLabel, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          SegmentedButton<SkillSessionType>(
            segments: SkillSessionType.values.map((type) {
              return ButtonSegment<SkillSessionType>(
                value: type,
                label: Text(_getSessionTypeLabel(l10n, type)),
              );
            }).toList(),
            selected: {_sessionType},
            onSelectionChanged: (newSelection) {
              setState(() {
                _sessionType = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 24),

          // Tags
          Text(l10n.tagsLabel, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SkillSessionTag.values.map((tag) {
              final isSelected = _tags.contains(tag);
              return FilterChip(
                label: Text(_getTagLabel(l10n, tag)),
                selected: isSelected,
                onSelected: (_) => _toggleTag(tag),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Duration
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.durationLabel, style: theme.textTheme.titleMedium),
              Text(
                l10n.durationMinutesLabel(_duration.round()),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: _duration,
            min: 5,
            max: 120,
            divisions: 23,
            label: l10n.durationMinutesLabel(_duration.round()),
            onChanged: (val) => setState(() => _duration = val),
          ),
          const SizedBox(height: 16),

          // Note
          TextFormField(
            controller: _noteController,
            decoration: InputDecoration(
              labelText: l10n.noteLabel,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          // Save
          FilledButton.icon(
            onPressed: _isSaving ? null : _saveLog,
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text('${l10n.saveLogButton} (+$xpPreview ${l10n.xpLabel})'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
          ),
        ],
      ),
    );
  }
}
