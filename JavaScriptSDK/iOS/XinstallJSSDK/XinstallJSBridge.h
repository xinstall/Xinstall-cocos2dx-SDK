//
//  XinstallJSBridge.h
//  Cocos2dxJSDemo-mobile
//
//  Created by huawenjie on 2021/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XinstallJSBridge : NSObject

+ (void)getInstallParams;

+ (void)registerWakeUpHandler;

+ (void)reportRegister;

+ (void)reportEventId:(NSString *)eventId eventValue:(NSNumber *)eventValue;

@end

NS_ASSUME_NONNULL_END
