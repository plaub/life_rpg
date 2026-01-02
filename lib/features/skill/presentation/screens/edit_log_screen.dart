import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:life_rpg/core/i18n/app_localizations.dart';
import 'package:life_rpg/features/skill/domain/entities/skill_log.dart';
import 'package:life_rpg/features/skill/presentation/providers/skill_providers.dart';
import 'package:life_rpg/features/skill/presentation/components/atoms/date_label.dart';
import '../../domain/logic/xp_calculator.dart';

class EditLogScreen extends ConsumerStatefulWidget {
  final String skillId;
  final String logId;

  const EditLogScreen({super.key, required this.skillId, required this.logId});

  @override
  ConsumerState<EditLogScreen> createState() => _EditLogScreenState();
}

class _EditLogScreenState extends ConsumerState<EditLogScreen> {
  SkillSessionType _sessionType = SkillSessionType.apply;
  final Set<SkillSessionTag> _tags = {};
  double _duration = 30;
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;
  bool _isDeleting = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _initialize(SkillLog log) {
    if (_isInitialized) return;
    _sessionType = log.sessionType;
    _tags.addAll(log.tags);
    _duration = (log.durationMinutes ?? 30).toDouble();
    _noteController.text = log.note ?? '';
    _selectedDate = log.date;
    _isInitialized = true;
  }

  int _calculateXP() {
    return XPCalculator.calculateXP(
      durationMinutes: _duration.round(),
      sessionType: _sessionType,
      tags: _tags.toList(),
    );
  }

  Future<void> _deleteLog() async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteLogButton),
        content: Text(l10n.deleteLogConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.deleteLogButton,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isDeleting = true);
    try {
      final logAsync = ref.read(
        skillLogProvider((skillId: widget.skillId, logId: widget.logId)),
      );
      final log = logAsync.value;
      if (log == null) return;

      final repo = ref.read(skillRepositoryProvider);

      // 2. Delete Log
      await repo.deleteLog(widget.logId);

      ref.invalidate(skillLogsProvider(widget.skillId));

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.logDeleted)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  Future<void> _saveLog(SkillLog currentLog) async {
    setState(() => _isSaving = true);
    try {
      final newXp = _calculateXP();

      // 2. Update Log
      final updatedLog = SkillLog(
        id: currentLog.id,
        userId: currentLog.userId,
        skill: currentLog.skill,
        date: _selectedDate,
        sessionType: _sessionType,
        tags: _tags.toList(),
        durationMinutes: _duration.round(),
        note: _noteController.text.trim(),
        xpEarned: newXp,
        createdAt: currentLog.createdAt,
      );

      final repo = ref.read(skillRepositoryProvider);
      await repo.updateLog(updatedLog);

      ref.invalidate(skillLogsProvider(widget.skillId));
      ref.invalidate(
        skillLogProvider((skillId: widget.skillId, logId: widget.logId)),
      );

      if (mounted) {
        final l10n = AppLocalizations.of(context);
        context.pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.logUpdated)));
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

  void _toggleTag(SkillSessionTag tag) {
    setState(() {
      if (_tags.contains(tag)) {
        _tags.remove(tag);
      } else {
        _tags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final logAsync = ref.watch(
      skillLogProvider((skillId: widget.skillId, logId: widget.logId)),
    );
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editLogButton),
        actions: [
          if (!_isDeleting)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _isSaving ? null : _deleteLog,
              tooltip: l10n.deleteLogButton,
            )
          else
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: logAsync.when(
        data: (log) {
          if (log == null) return const Center(child: Text('Log not found'));
          _initialize(log);

          final xpPreview = _calculateXP();

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                log.skill.name,
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
              const SizedBox(height: 32),

              // Session Type
              Text(l10n.sessionTypeLabel, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
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
              const SizedBox(height: 32),

              // Tags
              Text(l10n.tagsLabel, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
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
              const SizedBox(height: 32),

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
              const SizedBox(height: 24),

              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: l10n.noteLabel,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 40),

              FilledButton.icon(
                onPressed: _isSaving ? null : () => _saveLog(log),
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                label: Text('${l10n.save} (+$xpPreview ${l10n.xpLabel})'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
