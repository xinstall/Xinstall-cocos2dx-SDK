//
//  XinstallJSSDK.m
//  Xinstall
//
//  Created by huawenjie on 2021/1/7.
//

#import "XinstallJSSDK.h"
#import "XinstallSDK.h"
#import "XinstallJSDelegate.h"

NSString * const XinstallThirdVersion = @"XINSTALL_THIRDSDKVERSION_1.5.1_THIRDSDKVERSION_XINSTALL";
NSString * const XinstallThirdPlatform = @"XINSTALL_THIRDPLATFORM_COCOS2DXJS_THIRDPLATFORM_XINSTALL";

@implementation XinstallJSSDK

+ (void)init {
    NSLog(@"%@",XinstallThirdVersion);
    NSLog(@"%@",XinstallThirdPlatform);
    
    [XinstallSDK initWithDelegate:[XinstallJSDelegate defaultManager]];
}

+ (void)initWithAd:(NSString *)idfa {
    [XinstallSDK initWithDelegate:[XinstallJSDelegate defaultManager] idfa:idfa];
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
