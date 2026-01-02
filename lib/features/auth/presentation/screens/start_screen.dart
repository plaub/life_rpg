import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/app_localizations.dart';
import '../../../../core/router/route_names.dart';

/// Start/Welcome screen - first screen users see
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Icon/Logo placeholder
              Icon(
                Icons.rocket_launch,
                size: 120,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 32),

              // Welcome Title
              Text(
                localizations.welcomeTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                localizations.welcomeSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),

              // Login Button
              ElevatedButton(
                onPressed: () => context.push(RouteNames.login),
                child: Text(localizations.loginButton),
              ),
              const SizedBox(height: 16),

              // Signup Button
              OutlinedButton(
                onPressed: () => context.push(RouteNames.signup),
                child: Text(localizations.signupButton),
              ),
              const SizedBox(height: 32),

              // Guest Login Button (Dev Mode)
              TextButton(
                onPressed: () => context.push(RouteNames.guest),
                child: Text(localizations.guestButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
