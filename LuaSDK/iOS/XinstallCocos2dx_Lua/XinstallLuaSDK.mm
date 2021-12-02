//
//  XinstallLuaSDK.m
//  lua-tests iOS
//
//  Created by huawenjie on 2020/11/18.
//

#import "XinstallLuaSDK.h"
#import "XinstallSDK/XinstallSDK.h"
#import "XinstallLuaDelegate.h"
#import <AdServices/AAAttribution.h>

NSString * const XinstallThirdVersion = @"XINSTALL_THIRDSDKVERSION_1.5.5_THIRDSDKVERSION_XINSTALL";
NSString * const XinstallThirdPlatform = @"XINSTALL_THIRDPLATFORM_COCOS2DXLUA_THIRDPLATFORM_XINSTALL";

@interface XinstallLuaSDK()
@end

@implementation XinstallLuaSDK

+ (void)init {
    NSLog(@"%@",XinstallThirdVersion);
    NSLog(@"%@",XinstallThirdPlatform);
    
    [XinstallSDK initWithDelegate:[XinstallLuaDelegate defaultManager]];
}

+ (void)initWithAd:(NSDictionary *)adConfig; {
    NSString *idfa = @"";
    NSString *asaToken = @"";
    if ([adConfig isKindOfClass:[NSDictionary class]]) {
        idfa = adConfig[@"idfa"];
        if ([adConfig[@"asa"] boolValue]) {
            if (@available(iOS 14.3, *)) {
                NSError *error;
                asaToken = [AAAttribution attributionTokenWithError:&error];
            }
        }
    }
    
    [XinstallSDK initWithDelegate:[XinstallLuaDelegate defaultManager] idfa:idfa asaToken:asaToken];
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
