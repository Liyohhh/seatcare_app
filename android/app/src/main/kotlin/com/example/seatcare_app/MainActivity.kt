package com.example.seatcare_app

import android.bluetooth.BluetoothDevice
import android.companion.AssociationRequest
import android.companion.BluetoothLeDeviceFilter
import android.companion.CompanionDeviceManager
import android.content.Intent
import android.content.IntentSender
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "waby/bluetooth"
    private val REQUEST_CODE = 42
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "showDevicePicker" -> {
                    pendingResult = result
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        launchDevicePicker()
                    } else {
                        result.error(
                            "UNSUPPORTED",
                            "Android 8.0 or higher is required.",
                            null
                        )
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun launchDevicePicker() {
        val deviceManager =
            getSystemService(COMPANION_DEVICE_SERVICE) as CompanionDeviceManager

        val request = AssociationRequest.Builder()
            .addDeviceFilter(BluetoothLeDeviceFilter.Builder().build())
            .build()

        deviceManager.associate(
            request,
            object : CompanionDeviceManager.Callback() {
                override fun onDeviceFound(chooserLauncher: IntentSender) {
                    // This opens the native Android device picker dialog
                    startIntentSenderForResult(
                        chooserLauncher,
                        REQUEST_CODE,
                        null, 0, 0, 0
                    )
                }

                override fun onFailure(error: CharSequence?) {
                    pendingResult?.error(
                        "SCAN_FAILED",
                        error?.toString() ?: "Failed to scan for devices.",
                        null
                    )
                    pendingResult = null
                }
            },
            null
        )
    }

    @Suppress("OVERRIDE_DEPRECATION")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != REQUEST_CODE) return

        if (resultCode == RESULT_OK && data != null) {
            val device: BluetoothDevice? =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    data.getParcelableExtra(
                        CompanionDeviceManager.EXTRA_DEVICE,
                        BluetoothDevice::class.java
                    )
                } else {
                    @Suppress("DEPRECATION")
                    data.getParcelableExtra(CompanionDeviceManager.EXTRA_DEVICE)
                }

            val name = device?.name?.takeIf { it.isNotBlank() }
                ?: device?.address
                ?: "Waby Device"

            pendingResult?.success(name)
        } else {
            pendingResult?.error("CANCELLED", "No device selected.", null)
        }
        pendingResult = null
    }
}
