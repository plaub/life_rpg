package com.liferpg.life_rpg

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class LifeRpgWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        private fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            // Read data from SharedPreferences (written by home_widget from Flutter)
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

            val displayName = prefs.getString("displayName", "Player") ?: "Player"
            val level = prefs.getInt("level", 1)
            val xpCurrent = prefs.getInt("xpCurrent", 0)
            val xpTotal = prefs.getInt("xpTotal", 100)
            val totalXp = prefs.getInt("totalXp", 0)
            val totalSkills = prefs.getInt("totalSkills", 0)
            val totalTimeFormatted = prefs.getString("totalTimeFormatted", "0h 0m") ?: "0h 0m"

            // Calculate progress percentage
            val progressPercent = if (xpTotal > 0) (xpCurrent * 100) / xpTotal else 0

            // Build RemoteViews
            val views = RemoteViews(context.packageName, R.layout.life_rpg_widget)

            // Set avatar initial
            val initial = if (displayName.isNotEmpty()) displayName[0].uppercase() else "P"
            views.setTextViewText(R.id.widget_avatar_initial, initial)

            // Set display name
            views.setTextViewText(R.id.widget_display_name, displayName)

            // Set level
            views.setTextViewText(R.id.widget_level, context.getString(R.string.widget_level, level))

            // Set XP text
            views.setTextViewText(R.id.widget_xp_text, context.getString(R.string.widget_xp_format, xpCurrent, xpTotal))

            // Set progress bar
            views.setProgressBar(R.id.widget_xp_bar, 100, progressPercent, false)

            // Set stats
            views.setTextViewText(R.id.widget_total_xp, context.getString(R.string.widget_total_xp, totalXp))
            views.setTextViewText(R.id.widget_total_time, context.getString(R.string.widget_total_time, totalTimeFormatted))
            views.setTextViewText(R.id.widget_total_skills, context.getString(R.string.widget_total_skills, totalSkills))

            // Set up click intent to open the app
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            // Update the widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
