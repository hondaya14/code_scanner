package nqvno14.honhon.code_scanner


import android.Manifest
import android.app.Activity
import android.app.Application
import android.content.pm.PackageManager
import android.hardware.Camera
import android.os.Bundle
import com.journeyapps.barcodescanner.BarcodeView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class CodeScannerView(messenger: BinaryMessenger?, args: HashMap<String, Any>)
    : PlatformView, MethodChannel.MethodCallHandler {

    private var scanner: BarcodeView? = null
    private var isFlash: Boolean = false
    private var isPaused: Boolean = false


    init {
        CodeScannerObject.channel?.setMethodCallHandler(this)
        CodeScannerObject.activity?.application?.registerActivityLifecycleCallbacks(object : Application.ActivityLifecycleCallbacks {
            override fun onActivityPaused(act: Activity) {
                if (act == CodeScannerObject.activity && !isPaused && isCameraPermissionGranted()) {
                    scanner?.pause()
                }
            }

            override fun onActivityStopped(act: Activity) {
            }

            override fun onActivitySaveInstanceState(act: Activity, outState: Bundle) {
            }

            override fun onActivityDestroyed(act: Activity) {
            }

            override fun onActivityCreated(act: Activity, savedInstanceState: Bundle?) {
            }

            override fun onActivityStarted(act: Activity) {
            }

            override fun onActivityResumed(act: Activity) {
                if (act == CodeScannerObject.activity && !isPaused && isCameraPermissionGranted()) {
                    scanner?.resume()
                }
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startScan" -> startScan(result)
            "stopScan" -> stopScan(result)
            "turnOnLight" -> turnOnLight(result)
            "turnOffLight" -> turnOffLight(result)
            "toggleLight" -> toggleLight(result)
            "readDataFromGallery" -> CodeScannerObject.reader.getImage()
            else -> result.notImplemented()
        }
    }

    override fun getView(): BarcodeView? {
        return initCodeScannerView().apply { }
    }

    private fun initCodeScannerView(): BarcodeView? {
        if (scanner == null) {
            scanner = BarcodeView(CodeScannerObject.activity)
            scanner?.cameraSettings?.requestedCameraId = Camera.CameraInfo.CAMERA_FACING_BACK

        } else {
            if (isCameraPermissionGranted()) {
                if (!isPaused) scanner!!.resume()
            } else {
                requestCameraPermission()
            }
        }

        return scanner
    }


    override fun dispose() {
        scanner?.pause()
        scanner = null
    }


    private fun startScan(result: MethodChannel.Result) {
        if (isCameraPermissionGranted()) {
            try {
                scanner?.decodeContinuous { scanData ->
                    CodeScannerObject.channel?.invokeMethod("receiveScanData", scanData.text)
                }
            } catch (e: Exception) {
                result.error("UNKNOWN", "Unable to start scanning.", "")
            }
        } else {
            result.error("PERMISSION_DENIED", "Camera permission denied.", "")
        }
    }

    private fun stopScan(result: MethodChannel.Result){
        scanner?.stopDecoding()
    }

    private fun turnOnLight(result: MethodChannel.Result) {
        if (CodeScannerObject.activity!!.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)) {
            scanner?.setTorch(true)
            result.success(true)
        } else {
            result.error("NOT_HAS_LIGHT", "Light is not available.", "")
        }
    }

    private fun turnOffLight(result: MethodChannel.Result) {
        if (CodeScannerObject.activity!!.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)) {
            scanner?.setTorch(false)
            result.success(false)
        } else {
            result.error("NOT_HAS_LIGHT", "Light is not available.", "")
        }
    }

    private fun toggleLight(result: MethodChannel.Result) {
        if (CodeScannerObject.activity!!.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)) {
            isFlash = !isFlash
            scanner?.setTorch(isFlash)
            result.success(isFlash)
        } else {
            result.error("NOT_HAS_LIGHT", "Light is not available.", "")
        }
    }

    private fun isCameraPermissionGranted(): Boolean {
        return CodeScannerObject.activity?.checkSelfPermission(Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestCameraPermission() {
        CodeScannerObject.activity?.requestPermissions(arrayOf(Manifest.permission.CAMERA), CodeScannerObject.CAMERA_REQUEST_CODE)
    }
}

