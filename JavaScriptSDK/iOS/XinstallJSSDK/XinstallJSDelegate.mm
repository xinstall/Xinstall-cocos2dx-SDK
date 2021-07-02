//
//  XinstallJSDelegate.m
//  Xinstall
//
//  Created by huawenjie on 2021/1/7.
//

#import "XinstallJSDelegate.h"


@interface XinstallJSDelegate()

@property (nonatomic, strong) NSMutableArray *wakeUpBlocks;

@property (nonatomic, strong) XinstallData *wakeUpData;

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
- (void)xinstall_getWakeUpParams:(XinstallData *)appData {
    NSLog(@"执行了xinstall_getWakeUpParams:");
    if (self.wakeUpBlocks.count > 0) {
        for (id block in self.wakeUpBlocks) {
            void(^ wakeUpBlock)(XinstallData *) = (void(^)(XinstallData *))block;
            wakeUpBlock(appData);
        }
    } else {
        self.wakeUpData = appData;
    }
}

#pragma mark - public methods
- (void)getInstallDataBlock:(void (^)(XinstallData * _Nullable, XinstallError * _Nullable))installDataBlock {
    if (installDataBlock) {
        [[XinstallSDK defaultManager] getInstallParamsWithCompletion:installDataBlock];
    }
}

- (void)getWakeUpDataBlock:(void (^)(XinstallData * _Nullable))wakeUpDataBlock {
    if (self.wakeUpData) {
        if (wakeUpDataBlock) {
            XinstallData *wakeUpData = [[XinstallData alloc] init];
            wakeUpData.channelCode = self.wakeUpData.channelCode;
            wakeUpData.data = self.wakeUpData.data;
            wakeUpData.firstFetch = self.wakeUpData.isFirstFetch;
            wakeUpData.timeSpan = self.wakeUpData.timeSpan;
            
            wakeUpDataBlock(wakeUpData);
            [self.wakeUpBlocks addObject:[wakeUpDataBlock copy]];
            self.wakeUpData = nil;
        }
    } else {
        if (wakeUpDataBlock) {
            [self.wakeUpBlocks addObject:[wakeUpDataBlock copy]];
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

#pragma mark - setter and getter methods
- (NSMutableArray *)wakeUpBlocks {
    if (_wakeUpBlocks == nil) {
        _wakeUpBlocks = [[NSMutableArray alloc] init];
    }
    return _wakeUpBlocks;
}

#pragma mark - version methods
- (NSString *)xiSdkThirdVersion {
    return @"1.2.9";
}

- (NSInteger)xiSdkType {
    return 5;
}

@end
