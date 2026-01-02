import 'package:flutter/material.dart';
import 'app_localizations.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

/// Localization delegate for AppLocalizations.
/// Loads the appropriate translation based on device locale.
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['de', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'de':
        return AppLocalizationsDe();
      case 'en':
        return AppLocalizationsEn();
      default:
        return AppLocalizationsDe(); // Default to German
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
