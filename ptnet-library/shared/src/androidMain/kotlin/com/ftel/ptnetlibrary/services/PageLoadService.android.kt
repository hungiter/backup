package com.ftel.ptnetlibrary.services


import com.squareup.okhttp.OkHttpClient
import com.squareup.okhttp.Request
import com.squareup.okhttp.Response
import java.io.IOException
import kotlin.concurrent.thread

actual class PageLoadService {
    private val client = OkHttpClient()

    actual fun pageLoadTimer(address: String, callback: (Double) -> Unit) {
        if (address.isNullOrEmpty()) {
            callback(-1.0)
            return
        }

        var url = ""
        if (address.startsWith("http://") || address.startsWith("https://")) {
            url = address.trim()
        } else {
            url = "http://${address.trim()}"
        }

        val request: Request = Request.Builder().url(url).build()

        thread {
            val client = OkHttpClient()
            val startTime = System.currentTimeMillis()
            try {
                val response: Response = client.newCall(request).execute()
                val endTime = System.currentTimeMillis()
                val duration = endTime - startTime
                response.body()?.close()
                callback(duration.toDouble())
            } catch (e: IOException) {
                callback(-1.0)
            }
        }
    }
}