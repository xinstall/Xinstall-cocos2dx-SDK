//
//  XinstallData.h
//  XinstallSDK
//  安装/唤醒 数据模型
//  Created by Xinstall on 2020/5/7.
//  Copyright © 2021 Shu Bao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XinstallData : NSObject <NSSecureCoding>

- (instancetype)initWithData:(NSDictionary *)data
                 channelCode:(NSString *)channelCode;
                

/// 动态参数
@property (nonatomic, copy) NSDictionary *data;
/// 渠道编号
@property (nonatomic, copy) NSString *channelCode;
/// 时间间隔
@property (nonatomic, assign) NSInteger timeSpan;
/// 是否是第一次获取到该安装数据。只会在第一次获取到并回调时为YES，后续回调均为NO（唤醒数据中该字段始终为 NO）
@property (nonatomic, assign, getter=isFirstFetch) BOOL firstFetch;

@end

NS_ASSUME_NONNULL_END
