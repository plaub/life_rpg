import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

/// Theme mode provider - manages light/dark/system theme preference
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});

/// ThemeMode notifier - persists theme preference
class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const String _key = 'theme_mode';

  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final themeModeStr = prefs.getString(_key);
    
    if (themeModeStr != null) {
      return ThemeMode.values.firstWhere(
        (mode) => mode.toString() == themeModeStr,
        orElse: () => ThemeMode.system,
      );
    }
    
    return ThemeMode.system;
  }

  /// Set theme mode and persist to preferences
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, mode.toString());
  }
}
