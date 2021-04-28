//
//  XinstallLuaSDK.m
//  lua-tests iOS
//
//  Created by huawenjie on 2020/11/18.
//

#import "XinstallLuaSDK.h"
#import "XinstallSDK.h"
#import "XinstallLuaDelegate.h"

@interface XinstallLuaSDK()
@end

@implementation XinstallLuaSDK

+ (void)init {
    [XinstallSDK initWithDelegate:[XinstallLuaDelegate defaultManager]];
}

+ (BOOL)continueUserActivity:(NSUserActivity*_Nullable)userActivity{
    
    if ([XinstallSDK continueUserActivity:userActivity]) {
        
        return YES;
    }
    
    return NO;
}

+ (BOOL)handleSchemeURL:(NSURL *_Nullable)URL {
    if ([XinstallSDK handleSchemeURL: URL]) {
        return YES;
    }
    return NO;
}

/// 设置是否显示SDK日志
+ (void)setShowLog:(BOOL)isShow {
    [XinstallSDK setShowLog:isShow];
}

/// 是否显示SDK日志
+ (BOOL)isShowLog {
    return [XinstallSDK isShowLog];
}

@end
