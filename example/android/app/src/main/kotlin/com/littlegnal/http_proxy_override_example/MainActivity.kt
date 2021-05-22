package com.littlegnal.http_proxy_override_example

import com.littlegnal.http_proxy_override.setMockProxySetting
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor,
                "com.littlegnal.http_proxy_override.test")

        channel.setMethodCallHandler { call, result ->
            when(call.method) {
                "enableMockProxy"-> {
                    setMockProxySetting(
                        host = call.argument("host"),
                        port = call.argument("port"))
                    result.success(true)
                }
                "disableProxy" -> {
                    setMockProxySetting(host = null, port = null)
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
