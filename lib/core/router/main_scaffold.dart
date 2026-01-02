import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/i18n/app_localizations.dart';

/// Main scaffold with bottom navigation bar for the app.
/// Used with GoRouter's StatefulShellRoute to maintain navigation state.
class MainScaffold extends StatelessWidget {
  const MainScaffold({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: localizations.homeTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bolt), // Or workspace_premium, stars, auto_awesome
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
