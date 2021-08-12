//
//  XinstallLuaDelegate.h
//  lua-tests iOS
//
//  Created by huawenjie on 2020/11/19.
//

#import <Foundation/Foundation.h>
#import "XinstallSDK/XinstallSDK.h"
#import "XinstallSDK/XinstallData.h"

#import "cocos2d.h"

#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
#include "scripting/lua-bindings/manual/platform/ios/CCLuaObjcBridge.h"
#endif
USING_NS_CC;

NS_ASSUME_NONNULL_BEGIN

@interface XinstallLuaDelegate : NSObject <XinstallDelegate>

+ (XinstallLuaDelegate *)defaultManager;

- (void)getInstallDataBlock:(void (^_Nullable)(XinstallData * _Nullable, XinstallError * _Nullable ))installDataBlock;

- (void)getWakeUpDataBlock:(void(^ _Nullable)(XinstallData *_Nullable))wakeUpDataBlock;
// Tools
+(NSString *)jsonStringWithObject:(id)jsonObject;

@end

NS_ASSUME_NONNULL_END
