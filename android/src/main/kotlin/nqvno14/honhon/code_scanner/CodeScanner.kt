package nqvno14.honhon.code_scanner


import android.Manifest
import android.app.Activity
import android.app.Application
import android.content.Context
import android.content.pm.PackageManager
import android.hardware.Camera
import android.os.Bundle
import com.journeyapps.barcodescanner.BarcodeView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class CodeScannerView (messenger: BinaryMessenger?, args: HashMap<String, Any>)
    :PlatformView, MethodChannel.MethodCallHandler{

    private var scanner: BarcodeView? = null
    private val channel: MethodChannel = MethodChannel(messenger, "code_scanner")
    private var isFlash: Boolean = false
    private var isPaused: Boolean = false
//    private var pm: PackageManager


    init {
        channel.setMethodCallHandler(this)
        CodeScannerObject.activity?.application?.registerActivityLifecycleCallbacks( object : Application.ActivityLifecycleCallbacks{
            override fun onActivityPaused(act: Activity) {
                if (act == CodeScannerObject.activity && !isPaused){
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
                if (act == CodeScannerObject.activity && !isPaused){
                    scanner?.resume()
                }
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method){
            "startScan" -> startScan(result)
            "turnOnLight" -> turnOnLight(result)
            "turnOffLight" -> turnOffLight(result)
            "toggleLight" -> toggleLight(result)
            else -> result.notImplemented()
        }
    }

    override fun getView(): BarcodeView? {
        if(scanner==null){
            scanner = BarcodeView(CodeScannerObject.activity)
            scanner?.cameraSettings?.requestedCameraId = Camera.CameraInfo.CAMERA_FACING_BACK

        }else{
            scanner!!.resume()
        }
        return scanner
    }

    override fun dispose() {
        scanner?.pause()
        scanner = null
    }


    private fun startScan(result: MethodChannel.Result){
        if(CodeScannerObject.activity?.checkSelfPermission(Manifest.permission.CAMERA)==PackageManager.PERMISSION_GRANTED) {
            scanner?.decodeContinuous { scanData ->
                channel.invokeMethod("receiveScanData", scanData.text)
            }
        }else{
            result.error("PERMISSION_DENIED", "Camera permission denied.","")
        }

    }

  private fun turnOnLight(result: MethodChannel.Result){

      scanner?.setTorch(true)
      result.success(true)
      result.error("NOT_HAS_LIGHT","Light is not available.","")
  }

  private fun turnOffLight(result: MethodChannel.Result){
      scanner?.setTorch(false)
      result.success(false)
      result.error("NOT_HAS_LIGHT","Light is not available.","")
  }

  private fun toggleLight(result: MethodChannel.Result){

      isFlash = !isFlash
      scanner?.setTorch(isFlash)
      result.success(isFlash)
      result.error("NOT_HAS_LIGHT","Light is not available.","")
  }

}

