//
//  XinstallError.h
//  Xinstall
//  Xinstall 错误模型
//  Created by Xinstall on 2021/1/7.
//  Copyright © 2021 Shu Bao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XinstallErrorType) {
    XinstallErrorTypeConfig = -1,               // SDK 配置错误
    XinstallErrorTypeUnknow = 0,                // 未知错误
    XinstallErrorTypeNetwork,                   // 网络问题（没有网络 或 网络请求超时）
    XinstallErrorTypeNonData,                   // 没有获取到数据
    XinstallErrorTypeAppForbid,                 // 该 App 已被 Xinstall 后台封禁
    XinstallErrorTypePermissionDenied,          // 该操作不被允许（一般代表调用的方法没有开通权限）
    XinstallErrorTypeParams,                    // 入参不正确
    XinstallErrorTypeInitSDKUnfinished,         // SDK 初始化未成功完成
    XinstallErrorTypeNotValidWakeUp             // 没有通过 Xinstall Web SDK 集成的页面拉起
};

@interface XinstallError : NSObject

/// 错误类型
@property (nonatomic, assign, readonly) XinstallErrorType type;
/// 错误信息
@property (nonatomic, copy, readonly) NSString *errorMsg;

+ (instancetype)errorWithType:(XinstallErrorType)type message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
