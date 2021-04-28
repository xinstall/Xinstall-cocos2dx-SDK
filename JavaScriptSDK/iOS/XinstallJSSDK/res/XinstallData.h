//
//  XinstallData.h
//  XinstallSDK
//  安装/唤醒 数据模型
//  Created by Xinstall on 2020/5/7.
//  Copyright © 2020 shu bao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XinstallData : NSObject <NSSecureCoding>

- (instancetype)initWithData:(NSDictionary *)data
                 channelCode:(NSString *)channelCode;
                

@property (nonatomic, copy) NSDictionary *data;//动态参数
@property (nonatomic, copy) NSString *channelCode;//渠道编号
@property (nonatomic, assign) NSInteger timeSpan;//时间间隔s

@end

NS_ASSUME_NONNULL_END
