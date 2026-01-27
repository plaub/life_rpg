import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application configuration.
///
/// Best practice: Use environment variables (--dart-define) to control
/// feature flags and environment-specific settings.
class AppConfig {
  /// Whether the app is running in debug mode.
  ///
  /// This is true if:
  /// 1. The app is compiled in debug mode (kDebugMode).
  /// 2. OR the environment variable IS_DEBUG is set to true.
  final bool isDebug;

  const AppConfig({required this.isDebug});

  factory AppConfig.fromEnvironment() {
    const isDebugEnv = bool.fromEnvironment('IS_DEBUG', defaultValue: false);

    return const AppConfig(isDebug: kDebugMode || isDebugEnv);
  }
}

/// Provider for the application configuration.
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment();
});
