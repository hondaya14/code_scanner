package nqvno14.honhon.code_scanner

import android.app.Activity.RESULT_OK
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry


/** CodeScannerPlugin */
class CodeScannerPlugin : FlutterPlugin, ActivityAware, PluginRegistry.ActivityResultListener {


    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        val factory = CodeScannerFactory(binding.binaryMessenger)
        CodeScannerObject.channel = MethodChannel(binding.binaryMessenger, "code_scanner")
        binding.platformViewRegistry.registerViewFactory("code_scanner_view", factory)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        CodeScannerObject.activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        CodeScannerObject.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        CodeScannerObject.activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        CodeScannerObject.activity = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        // CodeReader process: pick up from gallery
        if (resultCode == RESULT_OK && requestCode == CodeScannerObject.CAMERA_REQUEST_CODE) {
            try {
                val uri = data?.data
                val bitmap = CodeScannerObject.reader.getBitmapFromUri(uri)
                CodeScannerObject.reader.sendReadResult(bitmap)
                return true
            } catch (e: Exception) {
                CodeScannerObject.reader.sendReadResult(null)
                return false
            }
        }
        return false
    }


}

