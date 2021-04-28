//
//  XinstallLuaBridge.m
//  lua-tests iOS
//
//  Created by huawenjie on 2020/11/19.
//

#import "XinstallLuaBridge.h"
#import "XinstallLuaDelegate.h"

@implementation XinstallLuaBridge

+(void)getInstall:(NSDictionary *)dict {
    NSLog(@"执行了Install方法");
    [[XinstallLuaDelegate defaultManager] getInstallDataBlock: ^(XinstallData * _Nullable appData, XinstallError * _Nullable error) {
        NSDictionary *installDic = @{};
        if (appData) {
            NSString *channelID = @"";
            NSString *datas = @"";
            NSString *timeSpan = @"";
            if (appData.data) {
                datas = [XinstallLuaDelegate jsonStringWithObject:appData.data];
            }
            
            if (appData.channelCode) {
                channelID = appData.channelCode;
            }
            
            timeSpan = [NSString stringWithFormat:@"%zd",appData.timeSpan];
            
            installDic = @{@"channelCode":channelID,@"bindData":datas,@"timeSpan":timeSpan};
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
    NSLog(@"执行了wakeUp方法");
    [[XinstallLuaDelegate defaultManager] getWakeUpDataBlock:^(XinstallData * _Nullable appData) {
        NSString *channelID = @"";
        NSString *datas = @"";
        NSString *timeSpan = @"";
        if (appData.data) {
            datas = [XinstallLuaDelegate jsonStringWithObject:appData.data];
        }
        
        if (appData.channelCode) {
            channelID = appData.channelCode;
        }
        
        timeSpan = [NSString stringWithFormat:@"%zd",appData.timeSpan];
        
        NSDictionary *installDic = @{@"channelCode":channelID,@"bindData":datas,@"timeSpan":timeSpan};
        NSString *json = [XinstallLuaDelegate jsonStringWithObject:installDic];
        NSLog(@"Xinstall:iOS原生层获取到返回的唤起参数为%@",json);
        int functionId = [[dict objectForKey:@"functionId"] intValue];
        
        LuaObjcBridge::pushLuaFunctionById(functionId);
        
        //将需要传递给 Lua function 的参数放入 Lua stack
        LuaObjcBridge::getStack()->pushString([json UTF8String]);//返回json字串
        LuaObjcBridge::getStack()->executeFunction(1);//1个参数
        LuaObjcBridge::releaseLuaFunctionById(functionId);//释放
        
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

@end
