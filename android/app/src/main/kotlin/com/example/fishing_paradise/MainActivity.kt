package com.example.fishing_paradise

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.fishing_paradise/config"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getGoogleMapsApiKey" -> {
                    val apiKey = call.arguments as String
                    // Store or use the API key as needed
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
