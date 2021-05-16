package nqvno14.honhon.code_scanner

import android.app.Activity
import io.flutter.plugin.common.MethodChannel

object CodeScannerObject {
    var channel: MethodChannel? = null
    var activity: Activity? = null
    const val CAMERA_REQUEST_CODE = 200
    var readSuccess: Boolean = false
    var reader: CodeReader = CodeReader()
}