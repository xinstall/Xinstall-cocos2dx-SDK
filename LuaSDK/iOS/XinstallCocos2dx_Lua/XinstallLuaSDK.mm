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



@end
