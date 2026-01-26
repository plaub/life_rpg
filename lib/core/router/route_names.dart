/// Route names for the app navigation
class RouteNames {
  RouteNames._();

  // Auth Routes
  static const String start = '/';
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String guest = '/auth/guest';

  // Main App Routes
  static const String main = '/main';
  static const String home = '/main/home';
  static const String skills = '/main/skills';
  static const String createSkill = '/main/skills/create';
  static const String skillDetail = '/main/skills/:id';
  static const String editSkill = '/main/skills/:id/edit';
  static const String editLog = '/main/skills/:id/logs/:logId/edit';
  static const String analytics = '/main/analytics';
  static const String settings = '/main/settings';
  static const String profile = '/main/home/profile';
  static const String profileEditDetails = '/main/home/profile/edit';
  static const String profileChangeEmail = '/main/home/profile/email';
  static const String profileChangePassword = '/main/home/profile/password';
  static const String profileConvertAccount = '/main/home/profile/convert';
  static const String profileAvatarBuilder = '/main/home/profile/avatar';
}
