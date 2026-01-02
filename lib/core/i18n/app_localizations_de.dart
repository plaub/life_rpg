import 'app_localizations.dart';

/// German (Deutsch) translations
class AppLocalizationsDe extends AppLocalizations {
  // Auth Screen Translations
  @override
  String get welcomeTitle => 'Willkommen bei Life RPG';

  @override
  String get welcomeSubtitle => 'Verwandle dein Leben in ein Abenteuer';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get signupButton => 'Registrieren';

  @override
  String get guestButton => 'Als Gast fortfahren';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get confirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get loginTitle => 'Anmelden';

  @override
  String get signupTitle => 'Registrieren';

  @override
  String get guestLoginTitle => 'Gast-Anmeldung';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get noAccount => 'Noch kein Konto?';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get hasAccount => 'Bereits ein Konto?';

  @override
  String get continueAsGuest => 'Als Gast fortfahren';

  @override
  String get userLabel => 'Benutzer';

  @override
  String get logoutButton => 'Abmelden';

  // Navigation
  @override
  String get homeTab => 'Home';

  @override
  String get analyticsTab => 'Analytics';

  @override
  String get settingsTab => 'Einstellungen';

  // Home Screen
  @override
  String get homeTitle => 'Home';

  @override
  String get homeWelcome => 'Willkommen zurück!';

  @override
  String get homeTotalXP => 'Gesamt-EP';

  @override
  String get homeTotalTime => 'Zeit investiert';

  @override
  String get homeTotalSkills => 'Skills';

  @override
  String get homeCategoryOverview => 'Kategorien';

  @override
  String get homeNoCategories => 'Keine Kategorien vorhanden';

  // Analytics Screen
  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsTotalXp => 'Gesamt-EP';

  @override
  String get analyticsSkills => 'Skills';

  @override
  String get analyticsDistribution => 'Skill-Verteilung';

  @override
  String get analyticsNotEnoughData => 'Nicht genügend Daten';

  @override
  String get analyticsLast30Days => 'Aktivität (30 Tage)';

  @override
  String get analyticsNoActivity => 'Noch keine Aktivität';

  @override
  String get analyticsError => 'Fehler beim Laden';

  // Settings Screen
  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get themeSection => 'Design';

  @override
  String get languageSection => 'Sprache';

  @override
  String get lightTheme => 'Hell';

  @override
  String get darkTheme => 'Dunkel';

  @override
  String get systemTheme => 'System';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageEnglish => 'English';

  // Common
  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get save => 'Speichern';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolgreich';

  // Auth Errors
  @override
  String get errorUserNotFound => 'Benutzer nicht gefunden';

  @override
  String get errorWrongPassword => 'Falsches Passwort';

  @override
  String get errorEmailAlreadyInUse => 'E-Mail wird bereits verwendet';

  @override
  String get errorInvalidEmail => 'Ungültige E-Mail-Adresse';

  @override
  String get errorWeakPassword => 'Passwort ist zu schwach';

  @override
  String get errorGenericAuth => 'Authentifizierungsfehler';

  // Validation
  @override
  String get emailRequired => 'Bitte E-Mail eingeben';

  @override
  String get invalidEmail => 'Ungültige E-Mail-Adresse';

  @override
  String get passwordRequired => 'Bitte Passwort eingeben';

  @override
  String get passwordTooShort => 'Passwort muss mindestens 6 Zeichen haben';

  @override
  String get confirmPasswordRequired => 'Bitte Passwort bestätigen';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get emailsDoNotMatch => 'E-Mail-Adressen stimmen nicht überein';

  // Skill Feature
  @override
  String get skillsTitle => 'Fähigkeiten';

  @override
  String get levelLabel => 'Level';

  @override
  String get levelLabelShort => 'Lvl';

  @override
  String get xpLabel => 'EP';

  @override
  String get categoryLabel => 'Kategorie';

  @override
  String get addSkillButton => 'Skill hinzufügen';

  @override
  String get editSkillButton => 'Skill bearbeiten';

  @override
  String get logsTab => 'Protokoll';

  @override
  String get statsTab => 'Statistik';

  @override
  String get quickLogButton => 'Schnell-Log';

  @override
  String get noteLabel => 'Notiz';

  @override
  String get durationLabel => 'Dauer (Min.)';

  @override
  String get saveLogButton => 'Log speichern';

  @override
  String get noSkillsHere => 'Noch keine Skills. Erstelle einen!';

  @override
  String get skillNameLabel => 'Skill Name';

  @override
  String get descriptionLabel => 'Beschreibung';

  @override
  String get descriptionOptionalLabel => 'Beschreibung (optional)';

  @override
  String get categoryRequired => 'Bitte wähle eine Kategorie';

  @override
  String get filterBy => 'Filter:';

  @override
  String get clearFilter => 'Filter löschen';

  @override
  String get allCategories => 'Alle';

  @override
  String get skillNameRequired => 'Bitte gib einen Namen ein';

  @override
  String get addCategoryTitle => 'Kategorie hinzufügen';

  @override
  String get categoryNameLabel => 'Name der Kategorie';

  @override
  String get categoryNameRequired => 'Bitte gib einen Kategorienamen ein';

  @override
  String get errorLoadingCategories => 'Fehler beim Laden der Kategorien';

  @override
  String get iconLabel => 'Icon';

  @override
  String get fieldRequired => 'Erforderlich';

  @override
  String levelUpMessage(int level) =>
      'Level aufgestiegen! Du bist jetzt Level $level!';

  @override
  String xpGainedMessage(int xp) => 'Log gespeichert! +$xp EP';

  @override
  String durationMinutesLabel(int minutes) => '$minutes Min.';

  @override
  String get skillNotFound => 'Skill nicht gefunden';

  @override
  String get noLogsYet => 'Noch keine Einträge. Fang an zu üben!';

  @override
  String get practiceSession => 'Übungseinheit';

  @override
  String get editLogButton => 'Log bearbeiten';

  @override
  String get deleteLogButton => 'Log löschen';

  @override
  String get deleteLogConfirmation =>
      'Bist du sicher, dass du diesen Eintrag löschen möchtest? Dein Fortschritt wird angepasst.';

  @override
  String get logUpdated => 'Log aktualisiert';

  @override
  String get logDeleted => 'Log gelöscht';

  @override
  String get deleteSkillButton => 'Skill löschen';

  @override
  String get deleteSkillConfirmation =>
      'Bist du sicher, dass du diesen Skill löschen möchtest? Alle zugehörigen Protokolle und Fortschritte gehen verloren.';

  // Skill Session Types & Tags
  @override
  String get sessionTypeLabel => 'Session-Typ';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get sessionTypeLearn => 'Lernen';

  @override
  String get sessionTypeApply => 'Anwenden';

  @override
  String get sessionTypeBoth => 'Beides';

  @override
  String get tagRepeat => 'Wiederholung';

  @override
  String get tagReview => 'Rückblick';

  @override
  String get tagTeach => 'Lehren';

  @override
  String get tagExperiment => 'Experimentieren';

  @override
  String get tagChallenge => 'Herausforderung';

  // Guest
  @override
  String get guestInfo =>
      'Du kannst die App als Gast erkunden, ohne ein Konto zu erstellen.';

  // Profile
  @override
  String get profileTitle => 'Profil';

  @override
  String get editProfileDetails => 'Details bearbeiten';

  @override
  String get changeEmail => 'E-Mail ändern';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get accountSettingsSection => 'Account-Einstellungen';

  @override
  String get displayNameLabel => 'Anzeigename';

  @override
  String get ageLabel => 'Alter';

  @override
  String get bioLabel => 'Bio';

  @override
  String get ageOptionalLabel => 'Alter (optional)';

  @override
  String get bioOptionalLabel => 'Bio (optional)';

  @override
  String get profileUpdatedSuccess => 'Profildetails aktualisiert';

  @override
  String get emailUpdatedSuccess =>
      'E-Mail erfolgreich aktualisiert. Bitte verifizieren Sie Ihre neue E-Mail, falls erforderlich.';

  @override
  String get passwordUpdatedSuccess => 'Passwort erfolgreich aktualisiert';

  @override
  String get currentEmailLabel => 'Aktuelle E-Mail';

  @override
  String get newEmailLabel => 'Neue E-Mail';

  @override
  String get confirmNewEmailLabel => 'Neue E-Mail bestätigen';

  @override
  String get securityPasswordPrompt =>
      'Zur Sicherheit gib bitte dein Passwort ein:';

  @override
  String get currentPasswordLabel => 'Aktuelles Passwort';

  @override
  String get newPasswordLabel => 'Neues Passwort';

  @override
  String get confirmNewPasswordLabel => 'Neues Passwort bestätigen';

  @override
  String get updateEmailButton => 'E-Mail aktualisieren';

  @override
  String get updatePasswordButton => 'Passwort aktualisieren';

  @override
  String get nameRequired => 'Name erforderlich';

  @override
  String get editDetailsSubtitle => 'Name, Alter, Bio';

  @override
  String get forgotPasswordTitle => 'Passwort vergessen';

  @override
  String get passwordResetEmailSent =>
      'E-Mail zum Zurücksetzen des Passworts wurde gesendet. Bitte schau in dein Postfach.';

  @override
  String get sendResetLink => 'Link senden';

  @override
  String get emailVerificationPending =>
      'E-Mail-Änderung ausstehend. Bitte bestätige den Link in der Verifizierungs-E-Mail.';
}
