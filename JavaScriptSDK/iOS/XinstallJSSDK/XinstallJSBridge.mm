//
//  XinstallJSBridge.m
//  Cocos2dxJSDemo-mobile
//
//  Created by huawenjie on 2021/1/7.
//

#import "XinstallJSBridge.h"
#import "XinstallJSDelegate.h"
#import "XinstallData.h"

using namespace cocos2d;

@implementation XinstallJSBridge

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

+ (void)getInstallParams {
    [[XinstallJSDelegate defaultManager] getInstallDataBlock:^(XinstallData * _Nullable installData, XinstallError * _Nullable error) {
        NSDictionary *installDic = @{};
        if (![XinstallJSBridge isEmptyData:installData]) {
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
        
        
        NSString *jsonOfInstall = [XinstallJSDelegate jsonStringWithObject:installDic];
        std::string jsonStr = [jsonOfInstall UTF8String];
#ifndef HAVE_INSPECTOR
        std::string funcName = [@"var xinstall = require(\"XinstallSDK\");xinstall._installCallback" UTF8String];
#else
        std::string funcName = [@"var xinstall = window.__require(\"XinstallSDK\");xinstall._installCallback" UTF8String];
#endif
        std::string jsCallStr = cocos2d::StringUtils::format("%s(%s);", funcName.c_str(),jsonStr.c_str());
#if CC_FIX_ARTIFACTS_BY_STRECHING_TEXEL_TMX
        BOOL success = se::ScriptEngine::getInstance()->evalString(jsCallStr.c_str());
#else
        BOOL success = ScriptingCore::getInstance()->evalString(jsCallStr.c_str());
#endif
        if (!success) {
            NSLog(@"XinstallJSSDK: 因为没有成功，所以通过直接引用_installCallback的方式进行回调。");
            std::string funcName = [@"_installCallback" UTF8String];
            std::string jsCallStr = cocos2d::StringUtils::format("%s(%s);", funcName.c_str(),jsonStr.c_str());
            
#if CC_FIX_ARTIFACTS_BY_STRECHING_TEXEL_TMX
            BOOL s = se::ScriptEngine::getInstance()->evalString(jsCallStr.c_str());
#else
            BOOL s = ScriptingCore::getInstance()->evalString(jsCallStr.c_str());
#endif
            if (!s) {
                NSLog(@"XinstallJSSDK: 回调失败，请在调用getInstallParams的地方调用_installCallback 回调方法，已获取回调数据，具体可以参考XinstallSDK.js");
            }
        } else {
            NSLog(@"XinstallJSSDK: _installCallback 参数回调成功。");
        }
    }];
}

+ (void)registerWakeUpHandler {
    [[XinstallJSDelegate defaultManager] getWakeUpDataBlock:^(XinstallData * _Nullable wakeUpData) {
        NSDictionary *wakeMsgDic = @{};
        
        if (![XinstallJSBridge isEmptyData:wakeUpData]) {
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
        
        NSString *jsonOfWakeUp = [XinstallJSDelegate jsonStringWithObject:wakeMsgDic];
        std::string jsonStr = [jsonOfWakeUp UTF8String];
        
#ifndef HAVE_INSPECTOR
        std::string funcName = [@"var xinstall = require(\"XinstallSDK\");xinstall._wakeupCallback" UTF8String];
#else
        std::string funcName = [@"var xinstall = window.__require(\"XinstallSDK\");xinstall._wakeupCallback" UTF8String];
#endif
        std::string jsCallStr = cocos2d::StringUtils::format("%s(%s);", funcName.c_str(),jsonStr.c_str());
#if CC_FIX_ARTIFACTS_BY_STRECHING_TEXEL_TMX
        BOOL success = se::ScriptEngine::getInstance()->evalString(jsCallStr.c_str());
#else
        BOOL success = ScriptingCore::getInstance()->evalString(jsCallStr.c_str());
#endif
        if (!success) {
            NSLog(@"XinstallJSSDK: 因为没有成功，所以通过直接引用_wakeupCallback的方式进行回调。");
            std::string funcName = [@"_wakeupCallback" UTF8String];
            std::string jsCallStr = cocos2d::StringUtils::format("%s(%s);", funcName.c_str(),jsonStr.c_str());
            
#if CC_FIX_ARTIFACTS_BY_STRECHING_TEXEL_TMX
            BOOL s = se::ScriptEngine::getInstance()->evalString(jsCallStr.c_str());
#else
            BOOL s = ScriptingCore::getInstance()->evalString(jsCallStr.c_str());
#endif
            if (!s) {
                NSLog(@"XinstallJSSDK: 回调失败，请在调用registerWakeUpHandler的地方调用_wakeupCallback 回调方法，已获取回调数据，具体可以参考XinstallSDK.js");
            }
        } else {
            NSLog(@"XinstallJSSDK: _wakeupCallback 参数回调成功。");
        }
        
    }];
}

+ (void)reportRegister {
    [XinstallSDK reportRegister];
}

+ (void)reportEventId:(NSString *)eventId eventValue:(NSNumber *)eventValue {
    [[XinstallSDK defaultManager] reportEventPoint:eventId eventValue:[eventValue longValue]];
}

@end
