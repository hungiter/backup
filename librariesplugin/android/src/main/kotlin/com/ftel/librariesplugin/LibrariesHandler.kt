package com.ftel.librariesplugin

import android.util.Log
import com.ftel.ptnetlibrary.services.*
import com.ftel.ptnetlibrary.dto.*

import java.util.concurrent.CompletableFuture

class LibrariesHandler(
    act: String,
    address: String,
    ttl: Int = -1,
    port: Int = -1
) {
    private var result: String = ""

    init {
        when (act) {
            "ping" -> result = pingResult(address, ttl)
            "pageLoad" -> result = pageLoadResult(address).get()
            "dnsLookup" -> result = dnsLookupResult(address).get()
            "portScan" -> result = portScanResult(address, port)
        }
    }

    private fun pingResult(inputAddress: String, timeToLive: Int): String {
        val pingdto: PingInfoDTO = PingService().execute(address = inputAddress, ttl = timeToLive)
        Log.d("Plugins - PingService", "${pingdto.toString()}")
        return "${pingdto.address}\n${pingdto.ip}\n${"%.2f".format(pingdto.time)} ms"
    }

    private fun pageLoadResult(inputAddress: String): CompletableFuture<String> {
        return CompletableFuture.supplyAsync {
            val pageLoadService = PageLoadService()
            try {
                val time = pageLoadService.pageLoadTimer(inputAddress)
                "Address: $inputAddress - Timer: $time ms\n"
            } catch (e: Exception) {
                throw RuntimeException("Failed to load page: ${e.message}")
            }
        }
    }

    private fun dnsLookupResult(inputAddress: String): CompletableFuture<String> {
        return CompletableFuture.supplyAsync {
            val dnsLookupService = NsLookupService()
            try {
                Log.d("Plugins - LookupService", "${dnsLookupService.toString()}")
                var dnsResult: String = ""
                // Cannot find source class for androidx.compose.runtime.SnapshotMutableStateImpl - dnsResponseDTO
                dnsResult = dnsLookupService.lookupResponse(inputAddress)
                result = dnsResult
                Log.d("Plugins - LookupService", "$dnsResult")
                dnsResult
            } catch (e: Exception) {
                throw RuntimeException("Failed to load page: ${e.message}")
            }
        }
    }

    private fun portScanResult(address: String, port: Int): String {
        return "$port"
    }

    fun getResult(): String {
        return this.result
    }
}
