import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:life_rpg/core/i18n/app_localizations.dart';
import 'package:life_rpg/features/auth/presentation/providers/auth_providers.dart';
import 'package:life_rpg/features/skill/domain/entities/skill_category.dart';
import 'package:life_rpg/features/skill/presentation/providers/skill_providers.dart';
import 'package:life_rpg/features/skill/presentation/components/atoms/icon_selector.dart';

class ManageCategoriesScreen extends ConsumerWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.categoryLabel)),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Center(child: Text(l10n.errorLoadingCategories));
          }

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return ListTile(
                leading: CircleAvatar(child: Text(category.icon)),
                title: Text(category.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _showCategoryDialog(context, ref, category),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _confirmDelete(context, ref, category),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('${l10n.error}: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showCategoryDialog(
    BuildContext context,
    WidgetRef ref, [
    SkillCategory? category,
  ]) async {
    final l10n = AppLocalizations.of(context);
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final nameController = TextEditingController(text: category?.name);
    String selectedIcon = category?.icon ?? '📁';

    final result = await showDialog<SkillCategory>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            category == null ? l10n.addCategoryTitle : l10n.editSkillButton,
          ),
          content: SingleChildScrollView(
            child: Column(
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
                  height: 300,
                  width: double.maxFinite,
                  child: IconSelector(
                    selectedIcon: selectedIcon,
                    onIconSelected: (icon) =>
                        setDialogState(() => selectedIcon = icon),
                    showPreview: true,
                  ),
                ),
              ],
            ),
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
                  id: category?.id ?? const Uuid().v4(),
                  userId: user.id,
                  key: nameController.text.trim().toLowerCase(),
                  name: nameController.text.trim(),
                  icon: selectedIcon,
                  color: category?.color ?? 'primary',
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
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    SkillCategory category,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
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
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.deleteSkillButton),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(skillRepositoryProvider).deleteCategory(category.id);
    }
  }
}
