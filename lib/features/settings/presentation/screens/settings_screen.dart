import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// Settings screen - theme and language configuration
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settingsTitle)),
      body: ListView(
        children: [
          // Theme Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              localizations.themeSection,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          RadioGroup<ThemeMode>(
            groupValue: themeMode,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).setThemeMode(value);
              }
            },
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.light_mode),
                  title: Text(localizations.lightTheme),
                  trailing: const Radio<ThemeMode>(value: ThemeMode.light),
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.light),
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: Text(localizations.darkTheme),
                  trailing: const Radio<ThemeMode>(value: ThemeMode.dark),
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.dark),
                ),
                ListTile(
                  leading: const Icon(Icons.settings_system_daydream),
                  title: Text(localizations.systemTheme),
                  trailing: const Radio<ThemeMode>(value: ThemeMode.system),
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.system),
                ),
              ],
            ),
          ),

          const Divider(),

          // Language Section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              localizations.languageSection,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          RadioGroup<String>(
            groupValue: locale.languageCode,
            onChanged: (value) {
              if (value != null) {
                ref.read(localeProvider.notifier).setLocale(Locale(value));
              }
            },
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(localizations.languageGerman),
                  trailing: const Radio<String>(value: 'de'),
                  onTap: () => ref
                      .read(localeProvider.notifier)
                      .setLocale(const Locale('de')),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(localizations.languageEnglish),
                  trailing: const Radio<String>(value: 'en'),
                  onTap: () => ref
                      .read(localeProvider.notifier)
                      .setLocale(const Locale('en')),
                ),
              ],
            ),
          ),

          const Divider(),

          // Logout
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final logoutUseCase = ref.read(logoutUseCaseProvider);
                await logoutUseCase();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
              child: Text(localizations.logoutButton),
            ),
          ),
        ],
      ),
    );
  }
}
