#import "FlutterPaxPrinterUtilityPlugin.h"
#if __has_include(<flutter_pax_printer_utility/flutter_pax_printer_utility-Swift.h>)
#import <flutter_pax_printer_utility/flutter_pax_printer_utility-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_pax_printer_utility-Swift.h"
#endif

@implementation FlutterPaxPrinterUtilityPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPaxPrinterUtilityPlugin registerWithRegistrar:registrar];
}
@end
