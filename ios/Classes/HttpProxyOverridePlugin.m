#import "HttpProxyOverridePlugin.h"
#if __has_include(<http_proxy_override/http_proxy_override-Swift.h>)
#import <http_proxy_override/http_proxy_override-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "http_proxy_override-Swift.h"
#endif

@implementation HttpProxyOverridePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHttpProxyOverridePlugin registerWithRegistrar:registrar];
}
@end
