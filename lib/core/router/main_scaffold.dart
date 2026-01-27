import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/app_localizations.dart';
import '../../features/avatar/presentation/providers/avatar_providers.dart';
import '../../features/avatar/presentation/widgets/level_up_overlay.dart';
import '../../features/skill/presentation/providers/skill_providers.dart';

/// Main scaffold with bottom navigation bar for the app.
/// Used with GoRouter's StatefulShellRoute to maintain navigation state.
class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Listen to level changes
    ref.listen(avatarProgressProvider, (previous, next) {
      final newLevel = next.value?.level;
      if (newLevel != null) {
        final hadPrevious = previous?.hasValue ?? false;

        if (hadPrevious) {
          final oldLevel = previous?.value?.level ?? 1;
          if (newLevel > oldLevel) {
            LevelUpOverlay.show(context, newLevel);
          }
        }
      }
    });

    // Listen for skill level up
    ref.listen(allSkillProgressProvider, (previous, next) {
      final newLevels = next.value;
      if (newLevels != null) {
        final skillNames = ref.read(skillNamesProvider).value ?? {};
        final hadPrevious = previous?.hasValue ?? false;
        final oldLevels = previous?.value ?? {};

        for (final entry in newLevels.entries) {
          final skillId = entry.key;
          final newLevel = entry.value;

          if (hadPrevious) {
            // If it's a new skill in this session, it started at level 1.
            final oldLevel = oldLevels[skillId] ?? 1;
            if (newLevel > oldLevel) {
              final skillName = skillNames[skillId] ?? 'Skill';
              LevelUpOverlay.show(context, newLevel, skillName: skillName);
            }
          }
        }
      }
    });

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType
            .fixed, // Use fixed to show all labels if needed
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: localizations.homeTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.bolt,
            ), // Or workspace_premium, stars, auto_awesome
            label: localizations.skillsTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics),
            label: localizations.analyticsTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: localizations.settingsTab,
          ),
        ],
      ),
    );
  }
}
