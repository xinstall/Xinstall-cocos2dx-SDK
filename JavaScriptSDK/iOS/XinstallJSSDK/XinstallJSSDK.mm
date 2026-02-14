//
//  XinstallJSSDK.m
//  Xinstall
//
//  Created by huawenjie on 2021/1/7.
//

#import "XinstallJSSDK.h"
#import "XinstallSDK.h"
#import "XinstallJSDelegate.h"
#import <AdServices/AAAttribution.h>

NSString * const XinstallThirdVersion = @"XINSTALL_THIRDSDKVERSION_1.7.6_THIRDSDKVERSION_XINSTALL";
NSString * const XinstallThirdPlatform = @"XINSTALL_THIRDPLATFORM_COCOS2DXJS_THIRDPLATFORM_XINSTALL";

@implementation XinstallJSSDK

+ (void)init {
    NSLog(@"%@",XinstallThirdVersion);
    NSLog(@"%@",XinstallThirdPlatform);
    
    [XinstallSDK initWithDelegate:[XinstallJSDelegate defaultManager]];
}

+ (void)initWithAd:(NSDictionary *)adConfig {
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
    
    [XinstallSDK initWithDelegate:[XinstallJSDelegate defaultManager] idfa:idfa asaToken:asaToken];
}

+ (BOOL)continueUserActivity:(NSUserActivity*_Nullable)userActivity {
    return [XinstallSDK continueUserActivity:userActivity];
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
