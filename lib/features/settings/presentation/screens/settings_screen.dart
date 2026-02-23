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
        padding: const EdgeInsets.all(20),
        children: [
          // Theme Section
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              localizations.themeSection,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Card(
            child: RadioGroup<ThemeMode>(
              groupValue: themeMode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                }
              },
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.light_mode_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(localizations.lightTheme),
                    trailing: const Radio<ThemeMode>(value: ThemeMode.light),
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.light),
                  ),
                  Divider(
                    height: 1,
                    indent: 56,
                    color: theme.colorScheme.outlineVariant,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.dark_mode_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(localizations.darkTheme),
                    trailing: const Radio<ThemeMode>(value: ThemeMode.dark),
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.dark),
                  ),
                  Divider(
                    height: 1,
                    indent: 56,
                    color: theme.colorScheme.outlineVariant,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.brightness_auto_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(localizations.systemTheme),
                    trailing: const Radio<ThemeMode>(value: ThemeMode.system),
                    onTap: () => ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.system),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Language Section
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              localizations.languageSection,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Card(
            child: RadioGroup<String>(
              groupValue: locale.languageCode,
              onChanged: (value) {
                if (value != null) {
                  ref.read(localeProvider.notifier).setLocale(Locale(value));
                }
              },
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.language_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(localizations.languageGerman),
                    trailing: const Radio<String>(value: 'de'),
                    onTap: () => ref
                        .read(localeProvider.notifier)
                        .setLocale(const Locale('de')),
                  ),
                  Divider(
                    height: 1,
                    indent: 56,
                    color: theme.colorScheme.outlineVariant,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.language_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(localizations.languageEnglish),
                    trailing: const Radio<String>(value: 'en'),
                    onTap: () => ref
                        .read(localeProvider.notifier)
                        .setLocale(const Locale('en')),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Logout
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final logoutUseCase = ref.read(logoutUseCaseProvider);
                await logoutUseCase();
              },
              icon: const Icon(Icons.logout_rounded),
              label: Text(localizations.logoutButton),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
