package com.ftel.librariesplugin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

/** LibrariesPlugin */
class LibrariesPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "librariesplugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        // Get data from dart
        val map: Map<String, Any?> = call.arguments as Map<String, Any?>

        val tmpAdd = (if (map.containsKey("address")) map["address"] else "8.8.8.8") as String
        val timeToLive = (if (map.containsKey("ttl")) map["ttl"] else -1) as Int
        val port = (if (map.containsKey("port")) map["port"] else -1) as Int
        // Note: Lỗi ở Ping, reset máy thử ( recommend: ko dùng AVD-Android Virtual Device (AndroidStudio-setting cực)
        when (call.method) {
            "getPingResult" -> result.success(
                LibrariesHandler(
                    "ping",
                    address = tmpAdd,
                    ttl = timeToLive
                ).getResult()
            )

            "getPageLoadResult" -> result.success(
                LibrariesHandler(
                    "pageLoad",
                    address = tmpAdd
                ).getResult()
            )

            "getDnsLookupResult" -> result.success(
                LibrariesHandler(
                    "dnsLookup",
                    address = tmpAdd
                ).getResult()
            )

            "getPortScanResult" -> result.success(
                LibrariesHandler(
                    "portScan",
                    address = tmpAdd,
                    port = port
                ).getResult()
            )
        }

        result.notImplemented()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}


// -----Begin-----
// Ping to AVD
//        PING youtube.com (142.250.192.110) 56(84) bytes of data.
//        --- youtube.com ping statistics ---
//        1 packets transmitted, 0 received, 100% packet loss, time 0ms
//        Domain: youtube.com
//        Ip: 142.250.192.110
//        Time: 0.0ms

// ----- End -----
