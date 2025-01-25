package com.example.clean_breathe

import android.appwidget.AppWidgetManager
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class HomeScreenWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: android.content.SharedPreferences
    ) {
        appWidgetIds.forEach { appWidgetId ->
            val cityName = widgetData.getString("currentCity", "Unknown City")
            val pollutionText = widgetData.getString("pollutionText", "No data")
            val average = widgetData.getString("average", "0")
            val measure = widgetData.getString("measure", "μg/m³")
            val backgroundColor = widgetData.getString("widgetBackgroundColor", "#ccb30000")

            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                setTextViewText(R.id.widget_city_name, cityName)
                setTextViewText(R.id.widget_pollution_text, pollutionText)
                setTextViewText(R.id.widget_average, average)
                setTextViewText(R.id.widget_measure, measure)

                val colorInt = android.graphics.Color.parseColor(backgroundColor)
                setInt(R.id.widget_root, "setBackgroundColor", colorInt)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
