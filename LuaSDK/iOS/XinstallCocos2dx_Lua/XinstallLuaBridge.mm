//
//  XinstallLuaBridge.m
//  lua-tests iOS
//
//  Created by huawenjie on 2020/11/19.
//

#import "XinstallLuaBridge.h"
#import "XinstallLuaDelegate.h"
#import "XinstallLuaSDK.h"

@implementation XinstallLuaBridge

+ (BOOL)isEmptyData:(XinstallData *)data {
    if (data == nil) {
        return YES;
    }
    
    if (data.channelCode.length > 0) {
        return NO;
    }
    
    if (data.timeSpan > 0) {
        return NO;
    }
    
    if ([data.data isKindOfClass:[NSDictionary class]]) {
        id objUo = [((NSDictionary *)data.data) objectForKey:@"uo"];
        if ([objUo isKindOfClass:[NSDictionary class]]) {
            if (((NSDictionary *)objUo).count > 0) {
                return NO;
            }
        } else if ([objUo isKindOfClass:[NSString class]]) {
            if (((NSString *)objUo).length > 0) {
                return NO;
            }
        }
    }
    
    if ([data.data isKindOfClass:[NSDictionary class]]) {
        id objCo = [((NSDictionary *)data.data) objectForKey:@"co"];
        if ([objCo isKindOfClass:[NSDictionary class]]) {
            if (((NSDictionary *)objCo).count > 0) {
                return NO;
            }
        } else if ([objCo isKindOfClass:[NSString class]]) {
            if (((NSString *)objCo).length > 0) {
                return NO;
            }
        }
    }
    
    return YES;
}

+ (void)init {
    [XinstallLuaSDK init];
}

+ (void)initWithAd:(NSDictionary *)dict {
    [XinstallLuaSDK initWithAd:dict];
}

+(void)getInstall:(NSDictionary *)dict {
    NSLog(@"执行了Install方法");
    [[XinstallLuaDelegate defaultManager] getInstallDataBlock: ^(XinstallData * _Nullable installData, XinstallError * _Nullable error) {
        NSDictionary *installDic = @{};
        if (![XinstallLuaBridge isEmptyData:installData]) {
            NSString *channelCode = @"";
            NSString * timeSpan = @"0";
            
            NSDictionary *uo;
            NSDictionary *co;
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            if ([installData.data isKindOfClass:[NSDictionary class]]) {
                uo = [installData.data objectForKey:@"uo"];
                co = [installData.data objectForKey:@"co"];
            }
            
            if (uo) {
                id uoJson;
                if ([uo isKindOfClass:[NSDictionary class]]) {
                    uoJson = uo;
                } else if ([uo isKindOfClass:[NSString class]]) {
                    uoJson = uo;
                }
            
                [dataDic setValue:uoJson?:@{} forKey:@"uo"];
            }
            
            if (co) {
                id coJson;
                if ([co isKindOfClass:[NSDictionary class]]) {
                    coJson = co;
                } else if ([uo isKindOfClass:[NSString class]]) {
                    coJson = co;
                }
            
                [dataDic setValue:coJson?:@{} forKey:@"co"];
            }
            
            if (installData.channelCode) {
                channelCode = installData.channelCode;
            }
            
            if (installData.timeSpan > 0) {
                timeSpan = [NSString stringWithFormat:@"%zd",installData.timeSpan];
            }
            installDic = @{@"channelCode": channelCode,@"timeSpan":timeSpan, @"data": dataDic,@"isFirstFetch":@(installData.isFirstFetch)};
        }
        
        NSString *json = [XinstallLuaDelegate jsonStringWithObject:installDic];
        NSLog(@"Xinstall:iOS原生层获取到返回的安装参数为%@",json);
        int functionId = [[dict objectForKey:@"functionId"] intValue];
        
        LuaObjcBridge::pushLuaFunctionById(functionId);
        
        //将需要传递给 Lua function 的参数放入 Lua stack
        LuaObjcBridge::getStack()->pushString([json UTF8String]);//返回json字串
        LuaObjcBridge::getStack()->executeFunction(1);//1个参数
        LuaObjcBridge::releaseLuaFunctionById(functionId);//释放
    }];
}

+(void)registerWakeUpHandler:(NSDictionary *)dict {
    NSLog(@"执行了 registerWakeUpHandler 方法");
    [[XinstallLuaDelegate defaultManager] getWakeUpDataBlock:^(XinstallData * _Nullable wakeUpData) {
        NSDictionary *wakeMsgDic = @{};
        
        if (![XinstallLuaBridge isEmptyData:wakeUpData]) {
            NSString *channelCode = @"";
            NSString * timeSpan = @"0";
            
            NSDictionary *uo;
            NSDictionary *co;
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            if ([wakeUpData.data isKindOfClass:[NSDictionary class]]) {
                uo = [wakeUpData.data objectForKey:@"uo"];
                co = [wakeUpData.data objectForKey:@"co"];
            }
            
            if (uo) {
                id uoJson;
                if ([uo isKindOfClass:[NSDictionary class]]) {
                    uoJson = uo;
                } else if ([uo isKindOfClass:[NSString class]]) {
                    uoJson = uo;
                }
            
                [dataDic setValue:uoJson?:@{} forKey:@"uo"];
            }
            
            if (co) {
                id coJson;
                if ([co isKindOfClass:[NSDictionary class]]) {
                    coJson = co;
                } else if ([uo isKindOfClass:[NSString class]]) {
                    coJson = co;
                }
            
                [dataDic setValue:coJson?:@{} forKey:@"co"];
            }
            
            if (wakeUpData.channelCode) {
                channelCode = wakeUpData.channelCode;
            }
            
            if (wakeUpData.timeSpan > 0) {
                timeSpan = [NSString stringWithFormat:@"%zd",wakeUpData.timeSpan];
            }

            wakeMsgDic = @{@"channelCode": channelCode,@"timeSpan":timeSpan, @"data": dataDic};
        }
        
        NSString *json = [XinstallLuaDelegate jsonStringWithObject:wakeMsgDic];
        NSLog(@"Xinstall:iOS原生层获取到返回的唤起参数为%@",json);
        int functionId = [[dict objectForKey:@"functionId"] intValue];
        
        LuaObjcBridge::pushLuaFunctionById(functionId);
        
        //将需要传递给 Lua function 的参数放入 Lua stack
        LuaObjcBridge::getStack()->pushString([json UTF8String]);//返回json字串
        LuaObjcBridge::getStack()->executeFunction(1);//1个参数
    }];
}

+ (void)registerWakeUpDetailHandler:(NSDictionary *)dict {
    NSLog(@"执行了 registerWakeUpDetailHandler 方法");

    [[XinstallLuaDelegate defaultManager] getWakeUpDetailDataBlock:^(XinstallData * _Nullable wakeUpData, XinstallError * _Nullable error) {
        NSDictionary *wakeMsgDic = @{};
        
        if (![XinstallLuaBridge isEmptyData:wakeUpData]) {
            NSString *channelCode = @"";
            NSString *timeSpan = @"0";
            
            NSDictionary *uo;
            NSDictionary *co;
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            if ([wakeUpData.data isKindOfClass:[NSDictionary class]]) {
                uo = [wakeUpData.data objectForKey:@"uo"];
                co = [wakeUpData.data objectForKey:@"co"];
            }
            
            if (uo) {
                id uoJson;
                if ([uo isKindOfClass:[NSDictionary class]]) {
                    uoJson = uo;
                } else if ([uo isKindOfClass:[NSString class]]) {
                    uoJson = uo;
                }
            
                [dataDic setValue:uoJson?:@{} forKey:@"uo"];
            }
            
            if (co) {
                id coJson;
                if ([co isKindOfClass:[NSDictionary class]]) {
                    coJson = co;
                } else if ([uo isKindOfClass:[NSString class]]) {
                    coJson = co;
                }
            
                [dataDic setValue:coJson?:@{} forKey:@"co"];
            }
            
            if (wakeUpData.channelCode) {
                channelCode = wakeUpData.channelCode;
            }
            
            if (wakeUpData.timeSpan > 0) {
                timeSpan = [NSString stringWithFormat:@"%zd",wakeUpData.timeSpan];
            }

            wakeMsgDic = @{ @"wakeUpData" : @{@"channelCode": channelCode,@"timeSpan":timeSpan, @"data": dataDic} , @"error" : @{}};
        } else {
            wakeMsgDic = @{ @"wakeUpData" : @{} , @"error" : @{ @"errorType" : @(error.type), @"errorMsg" : error.errorMsg }};
        }
        
        NSString *json = [XinstallLuaDelegate jsonStringWithObject:wakeMsgDic];
        NSLog(@"Xinstall:iOS原生层获取到返回的唤起参数为%@",json);
        int functionId = [[dict objectForKey:@"functionId"] intValue];
        
        LuaObjcBridge::pushLuaFunctionById(functionId);
        
        //将需要传递给 Lua function 的参数放入 Lua stack
        LuaObjcBridge::getStack()->pushString([json UTF8String]);//返回json字串
        LuaObjcBridge::getStack()->executeFunction(1);//1个参数
    }];
}

+ (void)reportRegister {
    [XinstallSDK reportRegister];
}

+ (void)reportEventPoint:(NSDictionary *)dict {
    NSString *eventId = [dict objectForKey:@"eventId"];
    long eventValue = [[dict objectForKey:@"eventValue"] longValue];
    [[XinstallSDK defaultManager] reportEventPoint:eventId eventValue:eventValue];
}

+ (void)reportShareByXinShareId:(NSDictionary *)dict {
    NSString *xinShareId = [dict objectForKey:@"xinShareId"];
    [[XinstallSDK defaultManager] reportShareByXinShareId:xinShareId];
}

+ (void)setShowLog:(NSDictionary *)dict {
    [XinstallSDK setShowLog:[dict[@"isOpen"] boolValue]];
}

@end
