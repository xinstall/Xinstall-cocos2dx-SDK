//
//  XinstallLuaSDK.h
//  lua-tests iOS
//
//  Created by huawenjie on 2020/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 主要将XinstallSDK的委托传给LuaDelegate
@interface XinstallLuaSDK : NSObject

+(void)init;
+(BOOL)continueUserActivity:(NSUserActivity*_Nullable)userActivity;
+ (BOOL)handleSchemeURL:(NSURL *_Nullable)URL;
/// 设置是否显示SDK日志
+ (void)setShowLog:(BOOL)isShow;

/// 是否显示SDK日志
+ (BOOL)isShowLog;

@end

NS_ASSUME_NONNULL_END
