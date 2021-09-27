//
//  XinstallLuaBridge.h
//  lua-tests iOS
//
//  Created by huawenjie on 2020/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XinstallLuaBridge : NSObject

+ (void)init;

+ (void)initWithAd:(NSDictionary *)dict;

+ (void)getInstall:(NSDictionary *)dict;

+ (void)registerWakeUpHandler:(NSDictionary *)dict;

+ (void)registerWakeUpDetailHandler:(NSDictionary *)dict;

+ (void)reportRegister;

+ (void)reportEventPoint:(NSDictionary *)dict;

+ (void)reportShareByXinShareId:(NSDictionary *)dict;

+ (void)setShowLog:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
