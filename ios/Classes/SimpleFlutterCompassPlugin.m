#import "SimpleFlutterCompassPlugin.h"
#import <simple_flutter_compass/simple_flutter_compass-Swift.h>

@implementation SimpleFlutterCompassPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSimpleFlutterCompassPlugin registerWithRegistrar:registrar];
}
@end
