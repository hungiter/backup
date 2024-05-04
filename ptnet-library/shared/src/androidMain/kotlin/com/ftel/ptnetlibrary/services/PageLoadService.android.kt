package com.ftel.ptnetlibrary.services

import android.util.Log
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import java.io.IOException

actual class PageLoadService {
    private val client = OkHttpClient()


    actual fun pageLoadTimer(address: String): Double {
        // Log.d("PageLoad - Url", "isNull:${address.replace(" ", "").isBlank()}")
        if (address.replace(" ", "").isBlank()) {
            return -1.0
        }

        var url: String = ""
        if (address.contains("http://") || address.contains("https://")) {
            url = address.trim()
        } else {
            url = "http://${address.trim()}"
        }
        // Log.d("PageLoad - Url", "Processed url: $url");

        val request: Request = Request.Builder().url(url).build()

        val startTime = System.currentTimeMillis()
        return try {
            val response: Response = client.newCall(request).execute()
            val endTime = System.currentTimeMillis()
            val duration = endTime - startTime
            response.body
                ?.close()
            duration.toDouble()
        } catch (e: IOException) {
            Log.d("Process", "Response's error ${e.message}");
            -2.0
        }
    }
}

// Response's error CLEARTEXT communication to " ... " not permitted by network security policy
// Check manifest
//  <application
//        android:usesCleartextTraffic="true"
//        ...
//   />