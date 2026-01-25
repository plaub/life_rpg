import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../providers/profile_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final user = ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context);
    final isAnonymous = user?.isAnonymous ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
              : (profile?.email ??
                    l10n.userLabel); // Localization for guest/unnamed

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Text(
                        displayName.isNotEmpty
                            ? displayName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(fontSize: 40),
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
                          color: Theme.of(
                            context,
                          ).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          l10n.guestLoginTitle,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onTertiaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      isAnonymous ? l10n.userLabel : displayName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (profile?.email != null && !isAnonymous)
                      Text(
                        profile!.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              if (isAnonymous) ...[
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          l10n.convertAccountTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.convertAccountSubtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
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
                ),
                const SizedBox(height: 16),
              ],

              Text(
                l10n.accountSettingsSection,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(l10n.editProfileDetails),
                      subtitle: Text(l10n.editDetailsSubtitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go(RouteNames.profileEditDetails),
                    ),
                    if (!isAnonymous) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: Text(l10n.changeEmail),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.go(RouteNames.profileChangeEmail),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: Text(l10n.changePassword),
                        trailing: const Icon(Icons.chevron_right),
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
