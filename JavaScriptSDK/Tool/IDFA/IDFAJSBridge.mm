//
//  IDFAJSBridge.m
//  Shubao
//
//  Created by Shubao on 2021/7/29.
//

#import "IDFAJSBridge.h"
#import "IDFAJSDelegate.h"

using namespace cocos2d;

@implementation IDFAJSBridge

+ (void)getIDFA {

    [[IDFAJSDelegate defaultManager] getIDFAWithCompletion:^(NSString * _Nonnull idfa) {
        NSString *jsonOfIdfa = [IDFAJSDelegate jsonStringWithObject:@{@"idfa":idfa}];
        std::string idfaString = [jsonOfIdfa UTF8String];
#ifndef HAVE_INSPECTOR
        std::string funcName = [@"var idfaTool = require(\"IDFATool\");idfaTool._getIDFACallback" UTF8String];
#else
        std::string funcName = [@"var idfaTool = window.__require(\"IDFATool\");idfaTool._getIDFACallback" UTF8String];
#endif
        std::string jsCallStr = cocos2d::StringUtils::format("%s(%s);", funcName.c_str(),idfaString.c_str());
#if CC_FIX_ARTIFACTS_BY_STRECHING_TEXEL_TMX
        BOOL success = se::ScriptEngine::getInstance()->evalString(jsCallStr.c_str());
#else
        BOOL success = ScriptingCore::getInstance()->evalString(jsCallStr.c_str());
#endif
        if (!success) {
            NSLog(@"IDFATool: 没有成功，通过直接引用 _getIDFACallback 的方式进行回调。");
            std::string funcName = [@"_getIDFACallback" UTF8String];
            std::string jsCallStr = cocos2d::StringUtils::format("%s(%s);", funcName.c_str(),idfaString.c_str());

#if CC_FIX_ARTIFACTS_BY_STRECHING_TEXEL_TMX
            BOOL s = se::ScriptEngine::getInstance()->evalString(jsCallStr.c_str());
#else
            BOOL s = ScriptingCore::getInstance()->evalString(jsCallStr.c_str());
#endif
            if (!s) {
                NSLog(@"IDFATool: 回调失败，请在调用getIDFA的地方调用 _getIDFACallback 回调方法");
            }
            
        }
    }];
    
}

@end
