import 'package:home_widget/home_widget.dart';

/// Service that pushes app data to the Android home screen widget
/// via SharedPreferences (used by the native AppWidgetProvider).
class WidgetService {
  static const _androidWidgetName = 'LifeRpgWidgetProvider';

  /// Save all widget-relevant data and trigger a widget refresh.
  static Future<void> updateWidget({
    required String displayName,
    required int level,
    required int xpCurrent,
    required int xpTotal,
    required int totalXp,
    required int totalSkills,
    required String totalTimeFormatted,
  }) async {
    await Future.wait([
      HomeWidget.saveWidgetData('displayName', displayName),
      HomeWidget.saveWidgetData('level', level),
      HomeWidget.saveWidgetData('xpCurrent', xpCurrent),
      HomeWidget.saveWidgetData('xpTotal', xpTotal),
      HomeWidget.saveWidgetData('totalXp', totalXp),
      HomeWidget.saveWidgetData('totalSkills', totalSkills),
      HomeWidget.saveWidgetData('totalTimeFormatted', totalTimeFormatted),
    ]);

    await HomeWidget.updateWidget(androidName: _androidWidgetName);
  }
}
