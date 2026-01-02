import 'app_localizations.dart';

/// English translations
class AppLocalizationsEn extends AppLocalizations {
  // Auth Screen Translations
  @override
  String get welcomeTitle => 'Welcome to Life RPG';

  @override
  String get welcomeSubtitle => 'Transform your life into an adventure';

  @override
  String get loginButton => 'Login';

  @override
  String get signupButton => 'Sign Up';

  @override
  String get guestButton => 'Continue as Guest';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get loginTitle => 'Login';

  @override
  String get signupTitle => 'Sign Up';

  @override
  String get guestLoginTitle => 'Guest Login';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get noAccount => "Don't have an account?";

  @override
  String get createAccount => 'Create Account';

  @override
  String get hasAccount => 'Already have an account?';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get userLabel => 'User';

  @override
  String get logoutButton => 'Logout';

  // Navigation
  @override
  String get homeTab => 'Home';

  @override
  String get analyticsTab => 'Analytics';

  @override
  String get settingsTab => 'Settings';

  // Home Screen
  @override
  String get homeTitle => 'Home';

  @override
  String get homeWelcome => 'Welcome back!';

  @override
  String get homeTotalXP => 'Total XP';

  @override
  String get homeTotalTime => 'Time Invested';

  @override
  String get homeTotalSkills => 'Skills';

  @override
  String get homeCategoryOverview => 'Categories';

  @override
  String get homeNoCategories => 'No categories found';

  // Analytics Screen
  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsTotalXp => 'Total XP';

  @override
  String get analyticsSkills => 'Skills';

  @override
  String get analyticsDistribution => 'Skill Distribution';

  @override
  String get analyticsNotEnoughData => 'Not enough data for chart';

  @override
  String get analyticsLast30Days => 'Last 30 Days Activity';

  @override
  String get analyticsNoActivity => 'No activity yet';

  @override
  String get analyticsError => 'Error loading stats';

  // Settings Screen
  @override
  String get settingsTitle => 'Settings';

  @override
  String get themeSection => 'Theme';

  @override
  String get languageSection => 'Language';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageEnglish => 'English';

  // Common
  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  // Auth Errors
  @override
  String get errorUserNotFound => 'User not found';

  @override
  String get errorWrongPassword => 'Wrong password';

  @override
  String get errorEmailAlreadyInUse => 'Email already in use';

  @override
  String get errorInvalidEmail => 'Invalid email address';

  @override
  String get errorWeakPassword => 'Password is too weak';

  @override
  String get errorGenericAuth => 'Authentication error';

  // Validation
  @override
  String get emailRequired => 'Please enter email';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get passwordRequired => 'Please enter password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordRequired => 'Please confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get emailsDoNotMatch => 'Emails do not match';

  // Skill Feature
  @override
  String get skillsTitle => 'Skills';

  @override
  String get levelLabel => 'Level';

  @override
  String get levelLabelShort => 'Lvl';

  @override
  String get xpLabel => 'XP';

  @override
  String get categoryLabel => 'Category';

  @override
  String get addSkillButton => 'Add Skill';

  @override
  String get editSkillButton => 'Edit Skill';

  @override
  String get logsTab => 'Logs';

  @override
  String get statsTab => 'Stats';

  @override
  String get quickLogButton => 'Quick Log';

  @override
  String get noteLabel => 'Note';

  @override
  String get durationLabel => 'Duration (min)';

  @override
  String get saveLogButton => 'Save Log';

  @override
  String get noSkillsHere => 'No skills yet. Create one!';

  @override
  String get skillNameLabel => 'Skill Name';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionOptionalLabel => 'Description (optional)';

  @override
  String get categoryRequired => 'Please select a category';

  @override
  String get filterBy => 'Filtered by:';

  @override
  String get clearFilter => 'Clear';

  @override
  String get allCategories => 'All';

  @override
  String get skillNameRequired => 'Please enter a name';

  @override
  String get addCategoryTitle => 'Add Category';

  @override
  String get categoryNameLabel => 'Category Name';

  @override
  String get categoryNameRequired => 'Please enter a category name';

  @override
  String get errorLoadingCategories => 'Error loading categories';

  @override
  String get iconLabel => 'Icon';

  @override
  String get fieldRequired => 'Required';

  @override
  String levelUpMessage(int level) => 'Level Up! You are now Level $level!';

  @override
  String xpGainedMessage(int xp) => 'Log saved! +$xp XP';

  @override
  String durationMinutesLabel(int minutes) => '$minutes min';

  @override
  String get skillNotFound => 'Skill not found';

  @override
  String get noLogsYet => 'No logs yet. Start practicing!';

  @override
  String get practiceSession => 'Practice Session';

  @override
  String get editLogButton => 'Edit Log';

  @override
  String get deleteLogButton => 'Delete Log';

  @override
  String get deleteLogConfirmation =>
      'Are you sure you want to delete this log? Progress will be adjusted.';

  @override
  String get logUpdated => 'Log updated';

  @override
  String get logDeleted => 'Log deleted';

  @override
  String get deleteSkillButton => 'Delete Skill';

  @override
  String get deleteSkillConfirmation =>
      'Are you sure you want to delete this skill? All associated logs and progress will be lost.';

  // Skill Session Types & Tags
  @override
  String get sessionTypeLabel => 'Session Type';

  @override
  String get tagsLabel => 'Tags';

  @override
  String get sessionTypeLearn => 'Learn';

  @override
  String get sessionTypeApply => 'Apply';

  @override
  String get sessionTypeBoth => 'Both';

  @override
  String get tagRepeat => 'Repeat';

  @override
  String get tagReview => 'Review';

  @override
  String get tagTeach => 'Teach';

  @override
  String get tagExperiment => 'Experiment';

  @override
  String get tagChallenge => 'Challenge';

  // Guest
  @override
  String get guestInfo =>
      'You can explore the app as a guest without creating an account.';

  // Profile
  @override
  String get profileTitle => 'Profile';

  @override
  String get editProfileDetails => 'Edit Details';

  @override
  String get changeEmail => 'Change Email';

  @override
  String get changePassword => 'Change Password';

  @override
  String get accountSettingsSection => 'Account Settings';

  @override
  String get displayNameLabel => 'Display Name';

  @override
  String get ageLabel => 'Age';

  @override
  String get bioLabel => 'Bio';

  @override
  String get ageOptionalLabel => 'Age (Optional)';

  @override
  String get bioOptionalLabel => 'Bio (Optional)';

  @override
  String get profileUpdatedSuccess => 'Profile details updated';

  @override
  String get emailUpdatedSuccess =>
      'Email updated successfully. Please verify your new email if required.';

  @override
  String get passwordUpdatedSuccess => 'Password updated successfully';

  @override
  String get currentEmailLabel => 'Current Email';

  @override
  String get newEmailLabel => 'New Email';

  @override
  String get confirmNewEmailLabel => 'Confirm New Email';

  @override
  String get securityPasswordPrompt =>
      'For security, please enter your password:';

  @override
  String get currentPasswordLabel => 'Current Password';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get confirmNewPasswordLabel => 'Confirm New Password';

  @override
  String get updateEmailButton => 'Update Email';

  @override
  String get updatePasswordButton => 'Update Password';

  @override
  String get nameRequired => 'Name required';

  @override
  String get editDetailsSubtitle => 'Name, Age, Bio';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get passwordResetEmailSent =>
      'Password reset email sent. Please check your inbox.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get emailVerificationPending =>
      'Email change pending. Please follow the link in the verification email.';
}
