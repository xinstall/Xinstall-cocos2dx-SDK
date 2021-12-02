//
//  XinstallJSBridge.h
//  Cocos2dxJSDemo-mobile
//
//  Created by huawenjie on 2021/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XinstallJSBridge : NSObject

+ (void)init;

+ (void)initWithAd:(NSString *)idfa asa:(BOOL)asa;

+ (void)getInstallParams;

+ (void)registerWakeUpHandler;

+ (void)registerWakeUpDetailHandler;

+ (void)reportRegister;

+ (void)reportEventId:(NSString *)eventId eventValue:(NSNumber *)eventValue;

+ (void)reportShareByXinShareId:(NSString *)xinShareId;

+ (void)setShowLog:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
