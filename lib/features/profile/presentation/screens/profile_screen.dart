import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final user = ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isAnonymous = user?.isAnonymous ?? false;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await ref.read(logoutUseCaseProvider)();
            },
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          final displayName = profile?.displayName.isNotEmpty == true
              ? profile!.displayName
              : (profile?.email ?? l10n.userLabel);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Header with gradient background
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            AppColors.darkSurface,
                            AppColors.darkSurfaceVariant.withValues(alpha: 0.5),
                          ]
                        : [
                            AppColors.lightPrimary.withValues(alpha: 0.08),
                            AppColors.lightSecondary.withValues(alpha: 0.06),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? theme.colorScheme.outlineVariant.withValues(
                            alpha: 0.3,
                          )
                        : theme.colorScheme.outlineVariant,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [AppColors.darkPrimary, AppColors.darkSecondary]
                              : [
                                  AppColors.headerGradientStart,
                                  AppColors.headerGradientEnd,
                                ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : '?',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isAnonymous)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.xpGold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          l10n.guestLoginTitle,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.xpGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      isAnonymous ? l10n.userLabel : displayName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (profile?.email != null && !isAnonymous)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          profile!.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (isAnonymous) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              AppColors.darkPrimary.withValues(alpha: 0.1),
                              AppColors.darkSecondary.withValues(alpha: 0.05),
                            ]
                          : [
                              AppColors.lightPrimary.withValues(alpha: 0.08),
                              AppColors.lightSecondary.withValues(alpha: 0.04),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.convertAccountTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.convertAccountSubtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.go(RouteNames.profileConvertAccount),
                        child: Text(l10n.convertAccountButton),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Section title
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  l10n.accountSettingsSection,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.person_outline_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(l10n.editProfileDetails),
                      subtitle: Text(l10n.editDetailsSubtitle),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.go(RouteNames.profileEditDetails),
                    ),
                    if (!isAnonymous) ...[
                      Divider(
                        height: 1,
                        indent: 56,
                        color: theme.colorScheme.outlineVariant,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.email_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(l10n.changeEmail),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.go(RouteNames.profileChangeEmail),
                      ),
                      Divider(
                        height: 1,
                        indent: 56,
                        color: theme.colorScheme.outlineVariant,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.lock_outline_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(l10n.changePassword),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () =>
                            context.go(RouteNames.profileChangePassword),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${l10n.error}: $err')),
      ),
    );
  }
}
