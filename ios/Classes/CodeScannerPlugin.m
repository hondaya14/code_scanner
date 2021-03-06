#import "CodeScannerPlugin.h"
#if __has_include(<code_scanner/code_scanner-Swift.h>)
#import <code_scanner/code_scanner-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "code_scanner-Swift.h"
#endif

@implementation CodeScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCodeScannerPlugin registerWithRegistrar:registrar];
}
@end
