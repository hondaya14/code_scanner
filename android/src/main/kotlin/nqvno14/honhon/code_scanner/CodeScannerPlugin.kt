package nqvno14.honhon.code_scanner

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry


/** CodeScannerPlugin */
class CodeScannerPlugin : FlutterPlugin, ActivityAware{

  companion object {
    @JvmStatic
    fun registerWith(registrar: PluginRegistry.Registrar) {
      val viewFactory = CodeScannerFactory(registrar.messenger())
      registrar.platformViewRegistry().registerViewFactory("code_scanner_view", viewFactory)
    }
  }

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    val factory = CodeScannerFactory(binding.binaryMessenger)
    binding.platformViewRegistry.registerViewFactory("code_scanner_view", factory)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    CodeScannerObject.activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    CodeScannerObject.activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    CodeScannerObject.activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    CodeScannerObject.activity = null
  }
}

