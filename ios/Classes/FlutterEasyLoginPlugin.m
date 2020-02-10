#import "FlutterEasyLoginPlugin.h"
#import <flutter_easy_login/flutter_easy_login-Swift.h>

@implementation FlutterEasyLoginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterEasyLoginPlugin registerWithRegistrar:registrar];
}
@end
