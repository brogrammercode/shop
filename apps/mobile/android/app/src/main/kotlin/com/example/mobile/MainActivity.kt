package com.example.mobile

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbConstants
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbDeviceConnection
import android.hardware.usb.UsbEndpoint
import android.hardware.usb.UsbInterface
import android.hardware.usb.UsbManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val channelName = "mobile/usb_receipt_printer"
    private val permissionAction = "com.example.mobile.USB_PERMISSION"
    private val epsonVendorId = 0x04B8
    private val logTag = "UsbReceiptPrinter"
    private val mainHandler = Handler(Looper.getMainLooper())
    private val executor = Executors.newSingleThreadExecutor()
    private var pendingPermissionResult: MethodChannel.Result? = null
    private var pendingPermissionTimeout: Runnable? = null
    private var receiverRegistered = false

    private val permissionReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            if (intent.action != permissionAction) {
                return
            }
            val device = intent.usbDevice()
            val granted = intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)
            completePermissionRequest(granted && device != null)
        }
    }

    private val usbManager: UsbManager
        get() = getSystemService(Context.USB_SERVICE) as UsbManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        registerPermissionReceiver()
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "listUsbDevices" -> result.success(listUsbDevices())
                "listUsbPrinters" -> result.success(listUsbPrinters())
                "requestUsbPermission" -> requestUsbPermission(result)
                "printReceiptBytes" -> printReceiptBytes(call, result)
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        if (receiverRegistered) {
            unregisterReceiver(permissionReceiver)
            receiverRegistered = false
        }
        executor.shutdown()
        super.onDestroy()
    }

    private fun registerPermissionReceiver() {
        if (receiverRegistered) {
            return
        }
        val filter = IntentFilter(permissionAction)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            registerReceiver(permissionReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            registerReceiver(permissionReceiver, filter)
        }
        receiverRegistered = true
    }

    private fun listUsbPrinters(): List<Map<String, Any>> {
        return listUsbDevices()
            .filter { it["isPrinterCandidate"] == true }
    }

    private fun listUsbDevices(): List<Map<String, Any>> {
        val devices = usbManager.deviceList.values.toList()
        devices.forEach { logDevice(it) }
        return devices
            .sortedWith(compareByDescending<UsbDevice> { isEpson(it) }.thenBy { it.deviceName })
            .map { deviceToMap(it) }
    }

    private fun requestUsbPermission(result: MethodChannel.Result) {
        val target = findTargetDevice()
        if (target == null) {
            val devices = usbManager.deviceList.values.toList()
            if (devices.isEmpty()) {
                result.error("PRINTER_NOT_CONNECTED", "Printer not connected", null)
            } else {
                result.error("EPSON_NOT_DETECTED", "Unable to detect Epson printer", null)
            }
            return
        }
        if (usbManager.hasPermission(target)) {
            result.success(true)
            return
        }
        if (pendingPermissionResult != null) {
            result.error("PRINTING_FAILED", "USB permission request already running", null)
            return
        }
        pendingPermissionResult = result
        val mutableFlag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.FLAG_MUTABLE
        } else {
            0
        }
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or mutableFlag
        val intent = Intent(permissionAction).setPackage(packageName)
        val permissionIntent = PendingIntent.getBroadcast(this, 0, intent, flags)
        val timeout = Runnable { completePermissionRequest(false) }
        pendingPermissionTimeout = timeout
        mainHandler.postDelayed(timeout, 30000)
        usbManager.requestPermission(target, permissionIntent)
    }

    private fun completePermissionRequest(granted: Boolean) {
        val timeout = pendingPermissionTimeout
        if (timeout != null) {
            mainHandler.removeCallbacks(timeout)
            pendingPermissionTimeout = null
        }
        val result = pendingPermissionResult
        pendingPermissionResult = null
        result?.success(granted)
    }

    private fun printReceiptBytes(call: MethodCall, result: MethodChannel.Result) {
        val values = call.argument<List<Int>>("bytes")
        if (values == null || values.isEmpty()) {
            result.error("PRINTING_FAILED", "Receipt bytes are empty", null)
            return
        }
        val bytes = ByteArray(values.size) { index -> values[index].toByte() }
        executor.execute {
            try {
                writeBytes(bytes)
                mainHandler.post { result.success(null) }
            } catch (error: UsbPrintException) {
                mainHandler.post { result.error(error.code, error.message, null) }
            } catch (error: Exception) {
                Log.e(logTag, "Printing failed", error)
                mainHandler.post { result.error("PRINTING_FAILED", "Printing failed", null) }
            }
        }
    }

    private fun writeBytes(bytes: ByteArray) {
        val target = findTargetDevice()
        if (target == null) {
            if (usbManager.deviceList.isEmpty()) {
                throw UsbPrintException("PRINTER_NOT_CONNECTED", "Printer not connected")
            }
            throw UsbPrintException("EPSON_NOT_DETECTED", "Unable to detect Epson printer")
        }
        if (!usbManager.hasPermission(target)) {
            throw UsbPrintException("USB_PERMISSION_DENIED", "USB permission denied")
        }
        val usbInterface = findPrintableInterface(target)
            ?: throw UsbPrintException("EPSON_NOT_DETECTED", "Unable to detect Epson printer")
        val endpoint = findBulkOutEndpoint(usbInterface)
            ?: throw UsbPrintException("EPSON_NOT_DETECTED", "Unable to detect Epson printer")
        val connection = usbManager.openDevice(target)
            ?: throw UsbPrintException("PRINTING_FAILED", "Unable to open USB printer")
        try {
            sendBytes(connection, usbInterface, endpoint, bytes)
        } finally {
            runCatching { connection.releaseInterface(usbInterface) }
            connection.close()
        }
    }

    private fun sendBytes(
        connection: UsbDeviceConnection,
        usbInterface: UsbInterface,
        endpoint: UsbEndpoint,
        bytes: ByteArray,
    ) {
        if (!connection.claimInterface(usbInterface, true)) {
            throw UsbPrintException("PRINTING_FAILED", "Unable to claim USB printer interface")
        }
        var offset = 0
        while (offset < bytes.size) {
            val length = minOf(16384, bytes.size - offset)
            val written = connection.bulkTransfer(endpoint, bytes, offset, length, 5000)
            if (written <= 0) {
                throw UsbPrintException("PRINTING_FAILED", "USB write failed")
            }
            offset += written
        }
    }

    private fun findTargetDevice(): UsbDevice? {
        val devices = usbManager.deviceList.values.toList()
        devices.forEach { logDevice(it) }
        return devices
            .filter { isPrinterCandidate(it) }
            .sortedWith(compareByDescending<UsbDevice> { isEpson(it) }.thenBy { it.deviceName })
            .firstOrNull()
    }

    private fun isPrinterCandidate(device: UsbDevice): Boolean {
        return isEpson(device) || hasPrinterInterface(device)
    }

    private fun isEpson(device: UsbDevice): Boolean {
        return device.vendorId == epsonVendorId
    }

    private fun hasPrinterInterface(device: UsbDevice): Boolean {
        for (index in 0 until device.interfaceCount) {
            if (device.getInterface(index).interfaceClass == UsbConstants.USB_CLASS_PRINTER) {
                return true
            }
        }
        return false
    }

    private fun findPrintableInterface(device: UsbDevice): UsbInterface? {
        for (index in 0 until device.interfaceCount) {
            val usbInterface = device.getInterface(index)
            if (usbInterface.interfaceClass == UsbConstants.USB_CLASS_PRINTER && findBulkOutEndpoint(usbInterface) != null) {
                return usbInterface
            }
        }
        for (index in 0 until device.interfaceCount) {
            val usbInterface = device.getInterface(index)
            if (findBulkOutEndpoint(usbInterface) != null) {
                return usbInterface
            }
        }
        return null
    }

    private fun findBulkOutEndpoint(usbInterface: UsbInterface): UsbEndpoint? {
        for (index in 0 until usbInterface.endpointCount) {
            val endpoint = usbInterface.getEndpoint(index)
            if (endpoint.type == UsbConstants.USB_ENDPOINT_XFER_BULK && endpoint.direction == UsbConstants.USB_DIR_OUT) {
                return endpoint
            }
        }
        return null
    }

    private fun deviceToMap(device: UsbDevice): Map<String, Any> {
        return mapOf(
            "vendorId" to device.vendorId,
            "productId" to device.productId,
            "deviceName" to device.deviceName,
            "manufacturerName" to safeManufacturerName(device),
            "productName" to safeProductName(device),
            "hasPermission" to usbManager.hasPermission(device),
            "isEpson" to isEpson(device),
            "isPrinterCandidate" to isPrinterCandidate(device),
        )
    }

    private fun logDevice(device: UsbDevice) {
        Log.d(
            logTag,
            "vendorId=${device.vendorId}, productId=${device.productId}, deviceName=${device.deviceName}, manufacturerName=${safeManufacturerName(device)}, productName=${safeProductName(device)}",
        )
    }

    private fun safeManufacturerName(device: UsbDevice): String {
        return runCatching { device.manufacturerName ?: "" }.getOrDefault("")
    }

    private fun safeProductName(device: UsbDevice): String {
        return runCatching { device.productName ?: "" }.getOrDefault("")
    }

    private fun Intent.usbDevice(): UsbDevice? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            getParcelableExtra(UsbManager.EXTRA_DEVICE, UsbDevice::class.java)
        } else {
            @Suppress("DEPRECATION")
            getParcelableExtra(UsbManager.EXTRA_DEVICE)
        }
    }
}

private class UsbPrintException(val code: String, override val message: String) : Exception(message)
