package com.africore.app

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.os.BatteryManager
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.Locale

class MainActivity : FlutterActivity() {
    private var previousCpu: Pair<Long, Long>? = readCpuCounters()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.africore.app/virtual_core")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getMetrics" -> result.success(readMetrics())
                    "openBatterySettings" -> try {
                        startActivity(Intent(Settings.ACTION_BATTERY_SAVER_SETTINGS))
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SETTINGS_UNAVAILABLE", e.message, null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun readMetrics(): Map<String, Any> {
        val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memory = ActivityManager.MemoryInfo()
        am.getMemoryInfo(memory)
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        val battery = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        val power = getSystemService(Context.POWER_SERVICE) as PowerManager
        val now = readCpuCounters()
        val load = if (now != null && previousCpu != null) {
            val total = now.first - previousCpu!!.first
            val idle = now.second - previousCpu!!.second
            if (total > 0) String.format(Locale.US, "%.1f%%",
                (100.0 * (total - idle) / total).coerceIn(0.0, 100.0)) else "Sampling…"
        } else "Sampling…"
        if (now != null) previousCpu = now
        val batteryIntent = registerReceiver(null, android.content.IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        val rawTemp = batteryIntent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1) ?: -1
        val temp = if (rawTemp > 0) String.format(Locale.US, "%.1f °C", rawTemp / 10.0) else "Unavailable"
        return mapOf(
            "cpuLoad" to load,
            "cpuCores" to Runtime.getRuntime().availableProcessors().toString(),
            "availableRam" to formatBytes(memory.availMem),
            "totalRam" to formatBytes(memory.totalMem),
            "batteryPercent" to if (battery >= 0) "$battery%" else "Unavailable",
            "batteryTemp" to temp,
            "lowMemory" to memory.lowMemory.toString(),
            "powerSave" to power.isPowerSaveMode.toString(),
            "androidVersion" to Build.VERSION.RELEASE
        )
    }

    private fun readCpuCounters(): Pair<Long, Long>? {
        return try {
            val line = File("/proc/stat").useLines { lines ->
                lines.firstOrNull { row -> row.startsWith("cpu ") }
            } ?: return null
            val values = line.trim().split(Regex("\\s+")).drop(1).map { it.toLong() }
            if (values.size < 4) return null
            Pair(values.sum(), values[3] + (values.getOrNull(4) ?: 0L))
        } catch (_: Exception) {
            null
        }
    }

    private fun formatBytes(bytes: Long): String {
        if (bytes <= 0L) return "Unavailable"
        val units = arrayOf("B", "KB", "MB", "GB", "TB")
        var value = bytes.toDouble()
        var index = 0
        while (value >= 1024.0 && index < units.lastIndex) { value /= 1024.0; index++ }
        return String.format(Locale.US, "%.2f %s", value, units[index])
    }
}
