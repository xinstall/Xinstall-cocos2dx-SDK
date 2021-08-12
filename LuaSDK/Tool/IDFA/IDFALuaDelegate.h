//
//  IDFALuaDelegate.h
//  Shubao
//
//  Created by Shubao on 2021/7/30.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"

#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
#include "scripting/lua-bindings/manual/platform/ios/CCLuaObjcBridge.h"
#endif
USING_NS_CC;


NS_ASSUME_NONNULL_BEGIN

@interface IDFALuaDelegate : NSObject

+ (instancetype)defaultManager;

- (void)getIDFAWithCompletion:(void(^)(NSString *))competion;

+ (NSString *)jsonStringWithObject:(id)jsonObject;

@end

NS_ASSUME_NONNULL_END
