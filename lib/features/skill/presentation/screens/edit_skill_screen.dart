import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:life_rpg/core/i18n/app_localizations.dart';
import 'package:life_rpg/features/auth/presentation/providers/auth_providers.dart';
import 'package:life_rpg/features/skill/domain/entities/skill.dart';
import 'package:life_rpg/features/skill/domain/entities/skill_category.dart';
import 'package:life_rpg/features/skill/presentation/providers/skill_providers.dart';
import 'package:life_rpg/features/skill/presentation/components/atoms/icon_selector.dart';

class EditSkillScreen extends ConsumerStatefulWidget {
  final String skillId;

  const EditSkillScreen({super.key, required this.skillId});

  @override
  ConsumerState<EditSkillScreen> createState() => _EditSkillScreenState();
}

class _EditSkillScreenState extends ConsumerState<EditSkillScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  SkillCategory? _selectedCategory;
  String _selectedIcon = '🚀';

  bool _isSaving = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _initializeFields(Skill skill) {
    if (_isInitialized) return;
    _nameController.text = skill.name;
    _descController.text = skill.description ?? '';
    _selectedCategory = skill.category;
    _selectedIcon = skill.icon;
    _isInitialized = true;
  }

  Future<void> _saveSkill(Skill currentSkill) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).categoryRequired)),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updatedSkill = currentSkill.copyWith(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        category: _selectedCategory!,
        icon: _selectedIcon,
        updatedAt: DateTime.now(),
      );

      await ref.read(skillRepositoryProvider).saveSkill(updatedSkill);

      // Invalidate detail provider to refresh UI on detail screen
      ref.invalidate(skillDetailProvider(updatedSkill.id));

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).success)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context).error}: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteSkill(String skillId) async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteSkillButton),
        content: Text(l10n.deleteSkillConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.deleteSkillButton,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isSaving = true);
    try {
      await ref.read(skillRepositoryProvider).deleteSkill(skillId);

      // Invalidate skills provider to refresh overview
      ref.invalidate(skillsProvider);

      if (mounted) {
        // Pop the Edit screen
        context.pop();
        // Pop the Detail screen (since the skill is gone)
        if (context.canPop()) {
          context.pop();
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.success)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.error}: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _showCreateCategoryDialog() async {
    final l10n = AppLocalizations.of(context);
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final nameController = TextEditingController();
    String selectedIcon = '📁';

    final result = await showDialog<SkillCategory>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(l10n.addCategoryTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.categoryNameLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: IconSelector(
                    selectedIcon: selectedIcon,
                    onIconSelected: (icon) =>
                        setDialogState(() => selectedIcon = icon),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                final newCat = SkillCategory(
                  id: const Uuid().v4(),
                  userId: user.id,
                  key: nameController.text.trim().toLowerCase(),
                  name: nameController.text.trim(),
                  icon: selectedIcon,
                  color: 'primary',
                );
                Navigator.pop(context, newCat);
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );

    if (result != null) {
      await ref.read(skillRepositoryProvider).saveCategory(result);
      setState(() {
        _selectedCategory = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final skillAsync = ref.watch(skillDetailProvider(widget.skillId));
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editSkillButton),
        actions: [
          skillAsync.maybeWhen(
            data: (skill) => skill != null
                ? IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: _isSaving ? null : () => _deleteSkill(skill.id),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: skillAsync.when(
        data: (skill) {
          if (skill == null) return Center(child: Text(l10n.skillNotFound));

          _initializeFields(skill);

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.skillNameLabel,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? l10n.fieldRequired
                      : null,
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descController,
                  decoration: InputDecoration(
                    labelText: l10n.descriptionOptionalLabel,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Category Selection
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: categoriesAsync.when(
                        data: (categories) {
                          final currentCat =
                              _selectedCategory != null &&
                                  categories.any(
                                    (c) => c.id == _selectedCategory!.id,
                                  )
                              ? categories.firstWhere(
                                  (c) => c.id == _selectedCategory!.id,
                                )
                              : null;

                          return DropdownButtonFormField<SkillCategory>(
                            initialValue: currentCat,
                            decoration: InputDecoration(
                              labelText: l10n.categoryLabel,
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.category),
                            ),
                            items: categories
                                .map<DropdownMenuItem<SkillCategory>>((cat) {
                                  return DropdownMenuItem<SkillCategory>(
                                    value: cat,
                                    child: Row(
                                      children: [
                                        Text(cat.icon),
                                        const SizedBox(width: 8),
                                        Text(cat.name),
                                      ],
                                    ),
                                  );
                                })
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedCategory = val),
                            validator: (val) =>
                                val == null ? l10n.fieldRequired : null,
                          );
                        },
                        loading: () => const LinearProgressIndicator(),
                        error: (err, _) =>
                            Text('${l10n.errorLoadingCategories}: $err'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: IconButton.filledTonal(
                        onPressed: _showCreateCategoryDialog,
                        icon: const Icon(Icons.add),
                        tooltip: l10n.addCategoryTitle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const SizedBox(height: 16),

                // Icon Selection
                Text(l10n.iconLabel, style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                IconSelector(
                  selectedIcon: _selectedIcon,
                  onIconSelected: (icon) =>
                      setState(() => _selectedIcon = icon),
                ),
                const SizedBox(height: 32),

                // Save Button
                FilledButton.icon(
                  onPressed: _isSaving ? null : () => _saveSkill(skill),
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: Text(l10n.save),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('${l10n.error}: $err')),
      ),
    );
  }
}
