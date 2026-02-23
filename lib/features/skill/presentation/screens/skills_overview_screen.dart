import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:life_rpg/core/i18n/app_localizations.dart';
import 'package:life_rpg/core/router/route_names.dart';
import 'package:life_rpg/features/skill/presentation/providers/skill_providers.dart';
import 'package:life_rpg/features/skill/presentation/components/organisms/skill_list.dart';
import 'package:life_rpg/features/skill/domain/entities/skill_category.dart';

class SkillsOverviewScreen extends ConsumerWidget {
  const SkillsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // Use the filtered provider
    final skillsAsync = ref.watch(filteredSkillsProvider);
    final activeFilterId = ref.watch(categoryFilterProvider);

    // We might want to show the category name, so we need categories too
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.skillsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_applications_rounded),
            onPressed: () {
              context.push(RouteNames.manageCategories);
            },
            tooltip: l10n.categoryLabel,
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                useRootNavigator: true,
                builder: (context) => const _FilterBottomSheet(),
              );
            },
          ),
        ],
        bottom: activeFilterId != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.06),
                  ),
                  child: Row(
                    children: [
                      Text(
                        l10n.filterBy,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InputChip(
                        label: Text(
                          categoriesAsync.asData?.value
                                  .firstWhere(
                                    (c) => c.id == activeFilterId,
                                    orElse: () => const SkillCategory(
                                      id: '',
                                      userId: '',
                                      name: '...',
                                      key: '',
                                      color: '000000',
                                      icon: '',
                                    ),
                                  )
                                  .name ??
                              'Unknown',
                        ),
                        onDeleted: () {
                          ref.read(categoryFilterProvider.notifier).set(null);
                        },
                        deleteIcon: const Icon(Icons.close_rounded, size: 18),
                      ),
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: skillsAsync.when(
        data: (skills) {
          if (skills.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 56,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noSkillsHere,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (activeFilterId != null) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () =>
                          ref.read(categoryFilterProvider.notifier).set(null),
                      child: Text(l10n.clearFilter),
                    ),
                  ],
                ],
              ),
            );
          }
          return SkillList(skills: skills);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(RouteNames.createSkill);
        },
        label: Text(l10n.addSkillButton),
        icon: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _FilterBottomSheet extends ConsumerWidget {
  const _FilterBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);
    final activeFilterId = ref.watch(categoryFilterProvider);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: Text(
              l10n.categoryLabel,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(color: theme.colorScheme.outlineVariant),
          Flexible(
            child: categoriesAsync.when(
              data: (categories) {
                if (categories.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(child: Text(l10n.errorLoadingCategories)),
                  );
                }

                return ListView(
                  shrinkWrap: true,
                  children: [
                    // Option: All
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary.withValues(
                          alpha: 0.1,
                        ),
                        child: Icon(
                          Icons.apps_rounded,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(l10n.allCategories),
                      trailing: activeFilterId == null
                          ? Icon(
                              Icons.check_rounded,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                      onTap: () {
                        ref.read(categoryFilterProvider.notifier).set(null);
                        Navigator.pop(context);
                      },
                    ),
                    Divider(
                      height: 1,
                      indent: 72,
                      color: theme.colorScheme.outlineVariant,
                    ),

                    // Categories
                    ...categories.map((category) {
                      Color catColor;
                      try {
                        final hex = category.color.replaceAll('#', '');
                        catColor = Color(int.parse('FF$hex', radix: 16));
                      } catch (_) {
                        catColor = theme.colorScheme.primary;
                      }

                      final isSelected = activeFilterId == category.id;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: catColor.withValues(alpha: 0.15),
                          child: Text(
                            category.icon.isNotEmpty ? category.icon : '📁',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(category.name),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_rounded,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                        onTap: () {
                          ref
                              .read(categoryFilterProvider.notifier)
                              .set(category.id);
                          Navigator.pop(context);
                        },
                      );
                    }),
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('${l10n.error}: $err'),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
