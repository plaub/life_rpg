import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/home_stats.dart';
import '../providers/home_providers.dart';
import '../../../skill/presentation/providers/skill_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';

/// Home screen - MVP Overview of life progress
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the home stats provider
    final statsAsync = ref.watch(homeStatsProvider);
    final localizations = AppLocalizations.of(context);

    // Pull to refresh logic
    Future<void> onRefresh() async {
      // Invalidate the provider to trigger a reload
      ref.invalidate(homeStatsProvider);
      await ref.read(homeStatsProvider.future);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // App Bar / Header
            SliverToBoxAdapter(child: _PlayerHeader(state: statsAsync)),

            // Spacing
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Category Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  localizations.homeCategoryOverview,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Grid Content
            statsAsync.when(
              data: (stats) {
                if (stats.categoryStats.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          localizations.homeNoCategories,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).disabledColor,
                              ),
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85, // Adjust for card height
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _CategoryCard(
                        category: stats.categoryStats[index],
                      );
                    }, childCount: stats.categoryStats.length),
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              error: (err, stack) => SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Error: $err',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _PlayerHeader extends ConsumerWidget {
  final AsyncValue<HomeStats> state;

  const _PlayerHeader({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final user = ref.watch(currentUserProvider);
    final userProfile = ref.watch(userProfileProvider).value;

    // Default values if loading
    final totalXP = state.asData?.value.totalXP ?? 0;
    final totalTime = state.asData?.value.totalTime ?? Duration.zero;
    final totalSkills = state.asData?.value.totalSkills ?? 0;

    // Formatting time
    final hours = totalTime.inHours;
    final minutes = totalTime.inMinutes.remainder(60);
    final timeString = '${hours}h ${minutes}m';

    // Name
    String displayName = 'Player';
    if (userProfile?.displayName.isNotEmpty == true) {
      displayName = userProfile!.displayName;
    } else if (user?.email != null) {
      final name = user!.email!.split('@').first;
      displayName = name.isNotEmpty
          ? name[0].toUpperCase() + name.substring(1)
          : 'Player';
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            children: [
              // Avatar & Greeting
              InkWell(
                onTap: () => context.go(RouteNames.profile),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          displayName[0],
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.homeWelcome,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            Text(
                              displayName,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatItem(
                    label: localizations.homeTotalXP,
                    value: '$totalXP',
                    icon: Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  _StatItem(
                    label: localizations.homeTotalTime,
                    value: timeString,
                    icon: Icons.timer_rounded,
                    color: Colors.blueAccent,
                  ),
                  _StatItem(
                    label: localizations.homeTotalSkills,
                    value: '$totalSkills',
                    icon: Icons.book_rounded,
                    color: Colors.purpleAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface, // Icon background remains surface
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryStats category;

  const _CategoryCard({required this.category});

  Color _parseColor(String hexCode) {
    try {
      final hex = hexCode.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final color = _parseColor(category.categoryColor);

    // Format Time
    final hours = category.totalTime.inHours;
    final minutes = category.totalTime.inMinutes.remainder(60); // Correction
    // Simpler: just hours if > 0, else minutes? Or "2h 15m"?
    // Space is limited in grid. Let's do "Xh Ym"
    final timeStr = '${hours}h ${minutes}m';

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            // Set filter in provider
            final container = ProviderScope.containerOf(context, listen: false);
            container
                .read(categoryFilterProvider.notifier)
                .set(category.categoryId);

            // Navigate to Skills tab
            context.go(RouteNames.skills);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon & Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        category.categoryIcon.isNotEmpty
                            ? category.categoryIcon
                            : '📁',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    // Maybe XP Badge here?
                  ],
                ),

                const Spacer(),

                Text(
                  category.categoryName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Stats
                _compactStat(
                  context,
                  Icons.star_rounded,
                  '${category.totalXP} ${localizations.xpLabel}',
                  Colors.amber,
                ),
                const SizedBox(height: 4),
                _compactStat(
                  context,
                  Icons.timer_outlined,
                  timeStr,
                  Colors.blueAccent,
                ),
                const SizedBox(height: 4),
                _compactStat(
                  context,
                  Icons.layers_outlined,
                  '${category.skillCount} Skills',
                  Colors.purpleAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _compactStat(
    BuildContext context,
    IconData icon,
    String text,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
