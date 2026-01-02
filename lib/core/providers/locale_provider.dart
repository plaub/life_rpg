import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_provider.dart';

/// Language/Locale provider - manages app language preference
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});

/// Locale notifier - persists language preference
class LocaleNotifier extends Notifier<Locale> {
  static const String _key = 'locale';

  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final languageCode = prefs.getString(_key);
    
    if (languageCode != null) {
      return Locale(languageCode, '');
    }
    
    return const Locale('de', '');
  }

  /// Set locale and persist to preferences
  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, locale.languageCode);
  }
}
