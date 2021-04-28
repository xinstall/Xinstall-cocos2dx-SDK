//
//  XinstallJSSDK.h
//  Xinstall
//
//  Created by huawenjie on 2021/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 主要讲XinstallSDK的委托传递给XinstallJSDelegate
@interface XinstallJSSDK : NSObject

+ (void)init;
+ (BOOL)continueUserActivity:(NSUserActivity*_Nullable)userActivity;
+ (BOOL)handleSchemeURL:(NSURL *_Nullable)URL;

@end

NS_ASSUME_NONNULL_END
