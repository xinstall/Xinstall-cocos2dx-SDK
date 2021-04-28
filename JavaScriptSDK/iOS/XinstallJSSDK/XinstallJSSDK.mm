//
//  XinstallJSSDK.m
//  Xinstall
//
//  Created by huawenjie on 2021/1/7.
//

#import "XinstallJSSDK.h"
#import "XinstallSDK.h"
#import "XinstallJSDelegate.h"

@implementation XinstallJSSDK

+ (void)init {
    [XinstallSDK initWithDelegate:[XinstallJSDelegate defaultManager]];
}

+ (BOOL)continueUserActivity:(NSUserActivity*_Nullable)userActivity {
    return [XinstallSDK continueUserActivity:userActivity];
}

@end
