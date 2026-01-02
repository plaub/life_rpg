import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/guest_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/start_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/skill/presentation/screens/skills_overview_screen.dart';
import '../../features/skill/presentation/screens/create_skill_screen.dart';
import '../../features/skill/presentation/screens/skill_detail_screen.dart';
import '../../features/skill/presentation/screens/edit_skill_screen.dart';
import '../../features/skill/presentation/screens/edit_log_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_details_screen.dart';
import '../../features/profile/presentation/screens/change_email_screen.dart';
import '../../features/profile/presentation/screens/change_password_screen.dart';
import 'main_scaffold.dart';
import 'route_names.dart';

/// GoRouter provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: RouteNames.start,
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isAuthRoute =
          state.matchedLocation.startsWith('/auth') ||
          state.matchedLocation == '/';

      // If user is logged in and trying to access auth routes, redirect to home
      if (isLoggedIn && isAuthRoute) {
        return RouteNames.home;
      }

      // If user is not logged in and trying to access protected routes, redirect to start
      if (!isLoggedIn && !isAuthRoute) {
        return RouteNames.start;
      }

      return null; // No redirect needed
    },
    routes: [
      // Start/Welcome Screen
      GoRoute(
        path: RouteNames.start,
        builder: (context, state) => const StartScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RouteNames.guest,
        builder: (context, state) => const GuestScreen(),
      ),

      // Main App with Bottom Navigation (StatefulShellRoute)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'profile',
                    builder: (context, state) => const ProfileScreen(),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) =>
                            const EditProfileDetailsScreen(),
                      ),
                      GoRoute(
                        path: 'email',
                        builder: (context, state) => const ChangeEmailScreen(),
                      ),
                      GoRoute(
                        path: 'password',
                        builder: (context, state) =>
                            const ChangePasswordScreen(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Skills Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.skills,
                builder: (context, state) => const SkillsOverviewScreen(),
                routes: [
                  GoRoute(
                    path: 'create', // /main/skills/create
                    builder: (context, state) => const CreateSkillScreen(),
                  ),
                  GoRoute(
                    path: ':id', // /main/skills/:id
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return SkillDetailScreen(skillId: id);
                    },
                    routes: [
                      GoRoute(
                        path:
                            'logs/:logId/edit', // /main/skills/:id/logs/:logId/edit
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          final logId = state.pathParameters['logId']!;
                          return EditLogScreen(skillId: id, logId: logId);
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: ':id/edit', // /main/skills/:id/edit
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return EditSkillScreen(skillId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Analytics Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.analytics,
                builder: (context, state) => const AnalyticsScreen(),
              ),
            ],
          ),
          // Settings Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
