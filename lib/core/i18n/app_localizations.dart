import 'package:flutter/material.dart';

/// Base class for app localizations.
/// Subclasses implement translations for specific languages.
abstract class AppLocalizations {
  /// Get the current locale's localizations
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('de', ''), // Deutsch
    Locale('en', ''), // English
  ];

  // Auth Screen Translations
  String get welcomeTitle;
  String get welcomeSubtitle;
  String get loginButton;
  String get signupButton;
  String get guestButton;
  String get emailLabel;
  String get passwordLabel;
  String get confirmPasswordLabel;
  String get loginTitle;
  String get signupTitle;
  String get guestLoginTitle;
  String get forgotPassword;
  String get noAccount;
  String get createAccount;
  String get hasAccount;
  String get continueAsGuest;
  String get userLabel;
  String get logoutButton;

  // Navigation
  String get homeTab;
  String get analyticsTab;
  String get settingsTab;

  // Home Screen
  String get homeTitle;
  String get homeWelcome;
  String get homeTotalXP;
  String get homeTotalTime;
  String get homeTotalSkills;
  String get homeCategoryOverview;
  String get homeNoCategories;

  // Analytics Screen
  String get analyticsTitle;
  String get analyticsTotalXp;
  String get analyticsSkills;
  String get analyticsDistribution;
  String get analyticsNotEnoughData;
  String get analyticsLast30Days;
  String get analyticsNoActivity;
  String get analyticsError;

  // Settings Screen
  String get settingsTitle;
  String get themeSection;
  String get languageSection;
  String get lightTheme;
  String get darkTheme;
  String get systemTheme;
  String get languageGerman;
  String get languageEnglish;

  // Common
  String get cancel;
  String get confirm;
  String get save;
  String get error;
  String get success;

  // Auth Errors
  String get errorUserNotFound;
  String get errorWrongPassword;
  String get errorEmailAlreadyInUse;
  String get errorInvalidEmail;
  String get errorWeakPassword;
  String get errorGenericAuth;

  // Validation
  String get emailRequired;
  String get invalidEmail;
  String get passwordRequired;
  String get passwordTooShort;
  String get confirmPasswordRequired;
  String get passwordsDoNotMatch;
  String get emailsDoNotMatch;

  // Skill Feature
  String get skillsTitle;
  String get levelLabel;
  String get levelLabelShort;
  String get xpLabel;
  String get categoryLabel;
  String get addSkillButton;
  String get editSkillButton;
  String get logsTab;
  String get statsTab;
  String get quickLogButton;
  String get noteLabel;
  String get durationLabel;
  String get saveLogButton;
  String get noSkillsHere;
  String get skillNameLabel;
  String get descriptionLabel;
  String get descriptionOptionalLabel;
  String get categoryRequired;
  // Filters
  String get filterBy;
  String get clearFilter;
  String get allCategories;

  String get skillNameRequired;
  String get addCategoryTitle;
  String get categoryNameLabel;
  String get categoryNameRequired;
  String get errorLoadingCategories;
  String get iconLabel;
  String get iconSelectorPrompt;
  String get iconSelectorSelected;
  String get iconSelectorNoRecents;
  String get iconSelectorSearchHint;
  String get fieldRequired;
  String levelUpMessage(int level);
  String xpGainedMessage(int xp);
  String durationMinutesLabel(int minutes);
  String get skillNotFound;
  String get noLogsYet;
  String get practiceSession;
  String get editLogButton;
  String get deleteLogButton;
  String get deleteLogConfirmation;
  String get logUpdated;
  String get logDeleted;
  String get deleteSkillButton;
  String get deleteSkillConfirmation;

  // Skill Session Types & Tags
  String get sessionTypeLabel;
  String get tagsLabel;
  String get sessionTypeLearn;
  String get sessionTypeApply;
  String get sessionTypeBoth;
  String get tagRepeat;
  String get tagReview;
  String get tagTeach;
  String get tagExperiment;
  String get tagChallenge;

  // Guest
  String get guestInfo;

  // Profile
  String get profileTitle;
  String get editProfileDetails;
  String get changeEmail;
  String get changePassword;
  String get accountSettingsSection;
  String get displayNameLabel;
  String get ageLabel;
  String get bioLabel;
  String get ageOptionalLabel;
  String get bioOptionalLabel;
  String get profileUpdatedSuccess;
  String get emailUpdatedSuccess;
  String get passwordUpdatedSuccess;
  String get currentEmailLabel;
  String get newEmailLabel;
  String get confirmNewEmailLabel;
  String get securityPasswordPrompt;
  String get currentPasswordLabel;
  String get newPasswordLabel;
  String get confirmNewPasswordLabel;
  String get updateEmailButton;
  String get updatePasswordButton;
  String get nameRequired;
  String get editDetailsSubtitle;
  String get forgotPasswordTitle;
  String get passwordResetEmailSent;
  String get sendResetLink;
  String get emailVerificationPending;
  String get convertAccountButton;
  String get convertAccountTitle;
  String get convertAccountSubtitle;
  String get convertAccountInfo;

  // Level Up / Skill Up Celebrations
  String get levelUpTitle;
  String get skillUpTitle;
  String skillUpMessage(String skillName, int level);
  String get levelUpSuccessBody;
  String get skillUpSuccessBody;
  String get continueButton;
}
