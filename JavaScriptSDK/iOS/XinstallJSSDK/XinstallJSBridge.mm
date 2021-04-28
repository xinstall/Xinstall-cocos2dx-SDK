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

+ (void)getInstallParams {
    [[XinstallJSDelegate defaultManager] getInstallDataBlock:^(XinstallData * _Nullable installData, XinstallError * _Nullable error) {
        NSDictionary *installDic = @{};
        if (installData) {
            NSString *channelID = @"";
            NSDictionary *datas = @{};
            NSString *timeSpan = @"";
            if (installData.data) {
                datas = installData.data;
            }
            
            if (installData.channelCode) {
                channelID = installData.channelCode;
            }
            
            timeSpan = [NSString stringWithFormat:@"%zd",installData.timeSpan];
            
            installDic = @{@"channelCode":channelID,@"data":datas,@"timeSpan":timeSpan,@"isFirstFetch":@(installData.isFirstFetch)};
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
        NSString *channelID = @"";
        NSDictionary *datas = @{};
        NSString *timeSpan = @"";
        if (wakeUpData.data) {
            datas = wakeUpData.data;
        }
        
        if (wakeUpData.channelCode) {
            channelID = wakeUpData.channelCode;
        }
        
        timeSpan = [NSString stringWithFormat:@"%zd",wakeUpData.timeSpan];
        
        NSDictionary *wakeUpdDic = @{@"channelCode":channelID,@"data":datas,@"timeSpan":timeSpan};
        
        NSString *jsonOfWakeUp = [XinstallJSDelegate jsonStringWithObject:wakeUpdDic];
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
