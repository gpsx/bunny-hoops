package com.example.bunny_hoops

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

class WidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                val dailyCount = widgetData.getInt("daily_count", 0)
                val lastUpdateTimestamp = widgetData.getLong("last_update_timestamp", 0L)
                
                // Midnight Reset Logic (T014)
                val currentTime = System.currentTimeMillis()
                val isToday = isSameDay(lastUpdateTimestamp, currentTime)
                
                val displayCount = if (isToday) dailyCount else 0
                setTextViewText(R.id.widget_counter_text, displayCount.toString())

                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    android.net.Uri.parse("myAppWidget://record")
                )
                setOnClickPendingIntent(R.id.widget_root, backgroundIntent)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun isSameDay(timestamp1: Long, timestamp2: Long): Boolean {
        if (timestamp1 == 0L || timestamp2 == 0L) return false
        val cal1 = java.util.Calendar.getInstance().apply { timeInMillis = timestamp1 }
        val cal2 = java.util.Calendar.getInstance().apply { timeInMillis = timestamp2 }
        return cal1.get(java.util.Calendar.YEAR) == cal2.get(java.util.Calendar.YEAR) &&
               cal1.get(java.util.Calendar.DAY_OF_YEAR) == cal2.get(java.util.Calendar.DAY_OF_YEAR)
    }
}
