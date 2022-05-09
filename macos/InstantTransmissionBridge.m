#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(InstantTransmissionModule, NSObject)

RCT_EXTERN_METHOD(moveCursorTo:(double)x y:(double)y)
RCT_EXTERN_METHOD(launchAtLoginEnabled: (RCTResponseSenderBlock*) callback)
RCT_EXTERN_METHOD(toggleLaunchAtLogin)
RCT_EXTERN_METHOD(persistData: (NSString*) data)
RCT_EXTERN_METHOD(getPersistedData: (RCTResponseSenderBlock*) callback)
RCT_EXTERN_METHOD(quitApp)

@end
