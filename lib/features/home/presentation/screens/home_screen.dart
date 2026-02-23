import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/home_stats.dart';
import '../providers/home_providers.dart';
import '../../../skill/presentation/providers/skill_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../avatar/presentation/providers/avatar_providers.dart';
import '../../../skill/domain/services/debug_xp_service.dart';
import '../../../../core/config/app_config.dart';
import '../../../widget/widget_updater.dart';

/// Home screen - MVP Overview of life progress
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the home stats provider
    final statsAsync = ref.watch(homeStatsProvider);
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final config = ref.watch(appConfigProvider);

    // Keep home screen widget in sync with latest data
    ref.watch(widgetUpdaterProvider);

    // Pull to refresh logic
    Future<void> onRefresh() async {
      // Invalidate the provider to trigger a reload
      ref.invalidate(homeStatsProvider);
      await ref.read(homeStatsProvider.future);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        color: theme.colorScheme.primary,
        onRefresh: onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // App Bar / Header
            SliverToBoxAdapter(child: _PlayerHeader(state: statsAsync)),

            // Spacing
            const SliverToBoxAdapter(child: SizedBox(height: 28)),

            // Category Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  localizations.homeCategoryOverview,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
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
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.explore_outlined,
                              size: 56,
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              localizations.homeNoCategories,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
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
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Debug Section
            if (config.isDebug)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Center(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final userId = ref.read(currentUserProvider)?.id;
                        if (userId != null) {
                          final repo = ref.read(skillRepositoryProvider);
                          final service = DebugXpService(repo);
                          await service.addDebugXp(userId);

                          // Force refresh of stats and progress
                          ref.invalidate(homeStatsProvider);
                          ref.invalidate(avatarProgressProvider);
                        }
                      },
                      icon: const Icon(Icons.bug_report),
                      label: const Text('DEBUG: +50 XP'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                        side: BorderSide(color: theme.colorScheme.error),
                      ),
                    ),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 48)),
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
    final isDark = theme.brightness == Brightness.dark;

    // Default values if loading
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.headerGradientStartDark,
                  AppColors.headerGradientEndDark,
                ]
              : [AppColors.headerGradientStart, AppColors.headerGradientEnd],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
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
                      Stack(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.2),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                displayName[0],
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Level Badge
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: ref
                                .watch(avatarProgressProvider)
                                .when(
                                  data: (progress) {
                                    if (progress == null) {
                                      return const SizedBox.shrink();
                                    }
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.xpGold,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isDark
                                              ? AppColors.darkSurface
                                              : AppColors.lightPrimary,
                                          width: 2,
                                        ),
                                      ),
                                      child: Text(
                                        '${progress.level}',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                      ),
                                    );
                                  },
                                  loading: () => const SizedBox.shrink(),
                                  error: (_, _) => const SizedBox.shrink(),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.homeWelcome,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            Text(
                              displayName,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Avatar Progress Bar
                            ref
                                .watch(avatarProgressProvider)
                                .when(
                                  data: (progress) {
                                    if (progress == null) {
                                      return const SizedBox.shrink();
                                    }
                                    final percent =
                                        progress.xpCurrent / progress.xpTotal;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 8,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            child: Stack(
                                              children: [
                                                // Background
                                                Container(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.15),
                                                ),
                                                // Progress
                                                FractionallySizedBox(
                                                  widthFactor: percent,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          AppColors.xpGold,
                                                          AppColors.xpGoldLight,
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            4,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Level ${progress.level}',
                                              style: theme.textTheme.labelMedium
                                                  ?.copyWith(
                                                    color:
                                                        AppColors.xpGoldLight,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              '${progress.xpCurrent} / ${progress.xpTotal} XP',
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                    color: Colors.white
                                                        .withValues(alpha: 0.6),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        // Compact Stats Row
                                        Row(
                                          children: [
                                            _compactHeaderStat(
                                              context,
                                              Icons.timer_rounded,
                                              timeString,
                                            ),
                                            const SizedBox(width: 16),
                                            _compactHeaderStat(
                                              context,
                                              Icons.book_rounded,
                                              '$totalSkills Skills',
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                  loading: () => ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      minHeight: 8,
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.15,
                                      ),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            AppColors.xpGold,
                                          ),
                                    ),
                                  ),
                                  error: (_, _) => const SizedBox.shrink(),
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _compactHeaderStat(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.7)),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
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
    final isDark = theme.brightness == Brightness.dark;

    // Format Time
    final hours = category.totalTime.inHours;
    final minutes = category.totalTime.inMinutes.remainder(60);
    final timeStr = '${hours}h ${minutes}m';

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? color.withValues(alpha: 0.2)
              : theme.colorScheme.outlineVariant,
          width: 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
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
                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    category.categoryIcon.isNotEmpty
                        ? category.categoryIcon
                        : '📁',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),

                const Spacer(),

                Text(
                  category.categoryName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
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
                  AppColors.xpGold,
                ),
                const SizedBox(height: 3),
                _compactStat(
                  context,
                  Icons.timer_outlined,
                  timeStr,
                  theme.colorScheme.primary,
                ),
                const SizedBox(height: 3),
                _compactStat(
                  context,
                  Icons.layers_outlined,
                  '${category.skillCount} Skills',
                  AppColors.levelPurple,
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
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
