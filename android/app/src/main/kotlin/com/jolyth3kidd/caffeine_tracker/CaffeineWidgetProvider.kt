package com.jolyth3kidd.caffeine_tracker

import android.app.PendingIntent
import android.content.Intent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetBackgroundReceiver
import com.jolyth3kidd.caffeine_tracker.R
import java.util.Date
import kotlin.math.pow
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Locale
import java.util.TimeZone

class CaffeineWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val packageName = context.packageName
        val isDarkMode = widgetData.getBoolean("isDarkMode", true)
        val layoutId = if (isDarkMode) R.layout.caffeine_widget_layout else R.layout.caffeine_widget_layout_light
        Log.d("CaffeineWidget", "onUpdate called for ${appWidgetIds.size} widgets. Dark mode: $isDarkMode, Layout: $layoutId")
        
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(packageName, layoutId).apply {
                val limit = widgetData.getInt("limit", 400)
                
                val totalMg = widgetData.getInt("totalMg", 0).coerceAtLeast(0)
                Log.d("CaffeineWidget", "Intake from data: $totalMg mg (Limit: $limit)")

                val progress = if (limit > 0) (totalMg * 100 / limit).coerceIn(0, 100) else 0
                val percentage = if (limit > 0) (totalMg * 100 / limit) else 0

                Log.d("CaffeineWidget", "Updating UI: $totalMg/$limit ($percentage%)")
                
                setTextViewText(R.id.widget_intake_value, "$totalMg")
                setTextViewText(R.id.widget_percentage_text, "$percentage% of Daily Goal")
                setProgressBar(R.id.widget_progress, 100, progress, false)
                
                // --- 1. OPEN APP ON CLICK ---
                val configIntent = context.packageManager.getLaunchIntentForPackage(packageName)
                if (configIntent != null) {
                    val configPendingIntent = PendingIntent.getActivity(
                        context, 
                        0, 
                        configIntent, 
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                    setOnClickPendingIntent(R.id.widget_root, configPendingIntent)
                    Log.d("CaffeineWidget", "App launch intent set for root view")
                }

                // --- 2. BACKGROUND REFRESH BUTTON ---
                Log.d("CaffeineWidget", "Setting up refresh button for widget $appWidgetId")

                val backgroundAction = "es.antonborri.home_widget.action.BACKGROUND"

                // PendingIntent for Refresh Button
                val refreshIntent = Intent(context, HomeWidgetBackgroundReceiver::class.java).apply {
                    action = backgroundAction
                    data = Uri.parse("home_widget://refresh")
                }
                val refreshPendingIntent = PendingIntent.getBroadcast(
                    context, 
                    103, 
                    refreshIntent, 
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
                )
                setOnClickPendingIntent(R.id.widget_button_refresh, refreshPendingIntent)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
