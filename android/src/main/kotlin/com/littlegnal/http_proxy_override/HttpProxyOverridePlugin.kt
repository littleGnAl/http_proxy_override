package com.littlegnal.http_proxy_override

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

private var mockProxyHost: String? = null
private var mockProxyPort: String? = null

/**
 * `setMockProxySetting` allow us to set a mock proxy host and port in integration test, and it should
 * only be used in test
 */
fun setMockProxySetting(host: String? = null, port: String? = null) {
  mockProxyHost = host
  mockProxyPort = port
}

/** HttpProxyOverridePlugin */
class HttpProxyOverridePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.littlegnal.http_proxy_override")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getProxyHost" -> {
        result.success(getProxyHost())
      }
      "getProxyPort" -> {
        result.success(getProxyPort())
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getProxyHost(): String? {
    return mockProxyHost ?: System.getProperty("http.proxyHost")
  }

  private fun getProxyPort(): String? {
    return mockProxyPort ?: System.getProperty("http.proxyPort")
  }
}
