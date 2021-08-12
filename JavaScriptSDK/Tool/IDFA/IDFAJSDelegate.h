//
//  IDFAJSDelegate.h
//  Shubao
//
//  Created by Shubao on 2021/7/29.
//

#import <Foundation/Foundation.h>

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

@interface IDFAJSDelegate : NSObject

+ (instancetype)defaultManager;

- (void)getIDFAWithCompletion:(void(^)(NSString *))competion;

+ (NSString *)jsonStringWithObject:(id)jsonObject;

@end

NS_ASSUME_NONNULL_END
