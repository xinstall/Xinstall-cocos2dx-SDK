//
//  IDFALuaBridge.m
//  Shubao
//
//  Created by Shubao on 2021/7/30.
//

#import "IDFALuaBridge.h"
#import "IDFALuaDelegate.h"

@implementation IDFALuaBridge

+ (void)getIDFA:(NSDictionary *)dict {

    [[IDFALuaDelegate defaultManager] getIDFAWithCompletion:^(NSString * _Nonnull idfa) {
        NSString *jsonOfIdfa = [IDFALuaDelegate jsonStringWithObject:@{@"idfa":idfa}];

        int functionId = [[dict objectForKey:@"functionId"] intValue];

        LuaObjcBridge::pushLuaFunctionById(functionId);

        //将需要传递给 Lua function 的参数放入 Lua stack
        LuaObjcBridge::getStack()->pushString([idfa UTF8String]);//返回json字串
        LuaObjcBridge::getStack()->executeFunction(1);//1个参数
        LuaObjcBridge::releaseLuaFunctionById(functionId);//释放
    }];

}

@end
