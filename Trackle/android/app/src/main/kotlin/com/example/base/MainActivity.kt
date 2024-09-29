package com.example.base

import android.app.AppOpsManager
import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Binder
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.widget.Toast

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app.battery/energy"

    override fun configureFlutterEngine(@NonNull flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getBatteryStats") {
                if (hasUsageStatsPermission()) {
                    val energyData = getBatteryUsageStats() // Get accessible app battery usage data
                    result.success(energyData)
                } else {
                    requestUsageStatsPermission()
                    result.error("PERMISSION_DENIED", "Usage stats permission not granted", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // Check if the app has permission to access usage stats
    private fun hasUsageStatsPermission(): Boolean {
        val appOpsManager = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOpsManager.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, Binder.getCallingUid(), packageName)
        return mode == AppOpsManager.MODE_ALLOWED
    }

    // Request the user to grant usage stats permission
    private fun requestUsageStatsPermission() {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
        startActivity(intent)
        Toast.makeText(this, "Please enable usage access for this app", Toast.LENGTH_LONG).show()
    }

    // Function to get battery usage stats over the last 24 hours (only for accessible apps)
    private fun getBatteryUsageStats(): Map<String, Double> {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        val startTime = endTime - (24 * 60 * 60 * 1000) // 24 hours in milliseconds

        val appUsageStats: MutableMap<String, Double> = mutableMapOf()

        // Retrieve app usage stats for the last 24 hours
        val stats = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, startTime, endTime)
        
        // Iterate over each usage stat and check if it's accessible
        for (usageStat in stats) {
            try {
                val appName = usageStat.packageName
                val batteryConsumption = (usageStat.totalTimeInForeground / 1000.0) // Rough energy estimate

                // Only add apps that report data
                if (batteryConsumption > 0) {
                    appUsageStats[appName] = batteryConsumption
                }
            } catch (e: Exception) {
                // Ignore apps that throw exceptions or don't allow access
                e.printStackTrace()
            }
        }

        return appUsageStats
    }
}
