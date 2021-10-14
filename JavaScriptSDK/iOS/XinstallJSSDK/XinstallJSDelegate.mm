//
//  XinstallJSDelegate.m
//  Xinstall
//
//  Created by huawenjie on 2021/1/7.
//

#import "XinstallJSDelegate.h"

/// 注册 唤醒监听 类型
typedef NS_ENUM(NSInteger, XinstallJSWakeUpListenerType) {
    XinstallJSWakeUpListenerTypeTypeUnknow = 0,           // 未知类型，一般为没有注册过唤醒监听
    XinstallJSWakeUpListenerTypeTypeWithoutDetail,        // 不包含错误的类型，只有获取唤醒参数成功时回调
    XinstallJSWakeUpListenerTypeTypeWithDetail            // 包含错误的类型，获取唤醒参数成功或者失败时都会回调
};

@interface XinstallJSDelegate()

@property (nonatomic, copy) XinstallJSWakeUpDataBlock wakeUpDataBlock;
@property (nonatomic, copy) XinstallJSWakeUpDetailDataBlock wakeUpDetailDataBlock;

/// 注册 唤醒监听 类型
@property (nonatomic, assign) XinstallJSWakeUpListenerType wakeUpListenerType;
/// 保存唤醒参数，因为唤醒的时机可能早于js注册唤醒
@property (nonatomic, strong) XinstallData *wakeUpData;
/// 保存唤醒错误信息，因为唤醒的时机可能早于js注册唤醒
@property (nonatomic, strong) XinstallError *wakeUpError;

@end

@implementation XinstallJSDelegate

+ (instancetype)defaultManager {
    static XinstallJSDelegate * sdkDelegate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sdkDelegate = [[super allocWithZone:NULL] init];
        //不是使用alloc方法，而是调用[[super allocWithZone:NULL] init]
        //已经重载allocWithZone基本的对象分配方法，所以要借用父类（NSObject）的功能来帮助出处理底层内存分配的杂物
    });
    return sdkDelegate;
}

///用alloc返回也是唯一实例
+ (instancetype) allocWithZone:(struct _NSZone *)zone {
    return [XinstallJSDelegate defaultManager] ;
}

/// 对对象使用copy也是返回唯一实例
- (instancetype)copyWithZone:(NSZone *)zone {
    return [XinstallJSDelegate defaultManager];
}

/// 对对象使用mutablecopy也是返回唯一实例
- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return [XinstallJSDelegate defaultManager] ;
}

#pragma mark - XinstallDelegate methods
- (void)xinstall_getWakeUpParams:(XinstallData *)appData error:(nullable XinstallError *)error {
    self.wakeUpData = appData;
    self.wakeUpError = error;
    
    switch (self.wakeUpListenerType) {
        case XinstallJSWakeUpListenerTypeTypeWithDetail:
        {
            if (self.wakeUpDetailDataBlock) {
                self.wakeUpDetailDataBlock(self.wakeUpData, self.wakeUpError);
            }
        }
            break;
        case XinstallJSWakeUpListenerTypeTypeWithoutDetail:
        {
            // 必须拿到了唤醒数据，才会回调
            if (self.wakeUpData && self.wakeUpDataBlock) {
                self.wakeUpDataBlock(self.wakeUpData);
            }
        }
            break;
        case XinstallJSWakeUpListenerTypeTypeUnknow:
        {
            // 什么都不做
        }
            break;
    }
}

#pragma mark - public methods
- (void)getInstallDataBlock:(void (^)(XinstallData * _Nullable, XinstallError * _Nullable))installDataBlock {
    if (installDataBlock) {
        [[XinstallSDK defaultManager] getInstallParamsWithCompletion:installDataBlock];
    }
}

- (void)getWakeUpDataBlock:(XinstallJSWakeUpDataBlock)wakeUpDataBlock {
    if (wakeUpDataBlock == nil) {
        return;
    }
    
    // 如果已经注册了带错误的唤醒监听，那么这个注册就不再生效
    if (self.wakeUpListenerType == XinstallJSWakeUpListenerTypeTypeWithDetail) {
        return;
    }
    // 当前没有注册过回调时，可以快速调用。这里需要判断一下，以免回调2次
    BOOL couldQuickInvoke = (self.wakeUpDataBlock == nil);
    // 设定类型和回调
    self.wakeUpListenerType = XinstallJSWakeUpListenerTypeTypeWithoutDetail;
    self.wakeUpDataBlock = wakeUpDataBlock;
    
    if (couldQuickInvoke) {
        if (self.wakeUpData) {
            wakeUpDataBlock(self.wakeUpData);
        }
    }
}

- (void)getWakeUpDetailDataBlock:(XinstallJSWakeUpDetailDataBlock)wakeUpDetailDataBlock {
    if (wakeUpDetailDataBlock == nil) {
        return;
    }
    
    // 当前没有注册过回调时，可以快速调用。这里需要判断一下，以免回调2次
    BOOL couldQuickInvoke = (self.wakeUpDetailDataBlock == nil);
    // 设定类型和回调
    self.wakeUpListenerType = XinstallJSWakeUpListenerTypeTypeWithDetail;
    self.wakeUpDetailDataBlock = wakeUpDetailDataBlock;
    
    if (couldQuickInvoke) {
        if (self.wakeUpData || self.wakeUpError) {
            wakeUpDetailDataBlock(self.wakeUpData, self.wakeUpError);
        }
    }
}

#pragma mark - Tools methods
+ (NSString *)jsonStringWithObject:(id)jsonObject{
    
    id arguments = (jsonObject == nil ? [NSNull null] : jsonObject);
    
    NSArray* argumentsWrappedInArr = [NSArray arrayWithObject:arguments];
    
    NSString* argumentsJSON = [self cp_JSONString:argumentsWrappedInArr];
    
    argumentsJSON = [argumentsJSON substringWithRange:NSMakeRange(1, [argumentsJSON length] - 2)];
    
    return argumentsJSON;
}

+ (NSString *)cp_JSONString:(NSArray *)array{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:0
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    if ([jsonString length] > 0 && error == nil){
        return jsonString;
    }else{
        return @"";
    }
}

#pragma mark - version methods
- (NSString *)xiSdkThirdVersion {
    return @"1.5.3";
}

- (NSInteger)xiSdkType {
    return 5;
}

@end
