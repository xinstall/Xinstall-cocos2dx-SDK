//
//  XinstallLuaBridge.h
//  lua-tests iOS
//
//  Created by huawenjie on 2020/11/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XinstallLuaBridge : NSObject

+ (void)getInstall:(NSDictionary *)dict;

+ (void)registerWakeUpHandler:(NSDictionary *)dict;

+ (void)reportRegister;

+ (void)reportEventPoint:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
