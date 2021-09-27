//
//  XinstallJSDelegate.h
//  Xinstall
//
//  Created by huawenjie on 2021/1/7.
//

#import <Foundation/Foundation.h>
#import "XinstallSDK.h"
#import "XinstallData.h"
#import "XinstallError.h"

#import "cocos2d.h"

#ifdef CC_FIX_ARTIFACTS_BY_STRECHING_TEXEL_TMX
#include "cocos/scripting/js-bindings/jswrapper/SeApi.h"
#else
#include "scripting/js-bindings/manual/ScriptingCore.h"
#endif
#ifndef HAVE_INSPECTOR
#include "ScriptingCore.h"
#endif


NS_ASSUME_NONNULL_BEGIN

typedef void(^XinstallJSWakeUpDataBlock)(XinstallData * _Nullable wakeUpData);
typedef void(^XinstallJSWakeUpDetailDataBlock)(XinstallData * _Nullable wakeUpData, XinstallError * _Nullable error);

@interface XinstallJSDelegate : NSObject<XinstallDelegate>

+ (instancetype)defaultManager;

- (void)getInstallDataBlock:(void (^_Nullable)(XinstallData * _Nullable, XinstallError * _Nullable ))installDataBlock;

- (void)getWakeUpDataBlock:(XinstallJSWakeUpDataBlock)wakeUpDataBlock;

- (void)getWakeUpDetailDataBlock:(XinstallJSWakeUpDetailDataBlock)wakeUpDetailDataBlock;

// Tools
+(NSString *)jsonStringWithObject:(id)jsonObject;

@end

NS_ASSUME_NONNULL_END
