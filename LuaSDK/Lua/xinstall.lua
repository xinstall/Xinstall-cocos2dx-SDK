local targetPlatform = cc.Application:getInstance():getTargetPlatform()

-- "org/cocos2dx/lua_tests/AppActivity" 为项目AppActivity的package加类名
local activityClassName = "org/cocos2dx/lua_tests/AppActivity"

local xinstall = class("xinstall")

function xinstall:getInstance(s,callback)
	print("call getInstance method start")
	if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
		local luaoc = require "cocos.cocos2d.luaoc"
        local args = {functionId = callback}
        local ok, ret = luaoc.callStaticMethod("XinstallLuaBridge","getInstall",args)
        if not ok then
            print("luaoc getInstall error:"..ret)
        end
    end
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
        local args = {s,callback}
        local signs = "(II)V"
        local ok,ret = luaj.callStaticMethod(activityClassName,"getInstallParam",args,signs)
        if not ok then
            print("luaoc ggetInstallParam error:"..ret)
        end
    end    
	-- body
end

function xinstall:registerWakeUpHandler(callback)
	print("call registerWakeupHandler method start")
	if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        local luaoc = require "cocos.cocos2d.luaoc"
        local args = {functionId = callback}
        local ok, ret = luaoc.callStaticMethod("XinstallLuaBridge","registerWakeUpHandler",args)
        if not ok then
            print("luaoc registerWakeUpHandler error:"..ret)
        end
    end
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
        local args = {callback}
        local signs = "(I)V"
        local ok,ret = luaj.callStaticMethod(activityClassName,"registerWakeupCallback",args,signs)
        if not ok then
            print("luaoc getInstallParam error:"..ret)
        end
    end   
	-- body
end

function xinstall:reportRegister()
    print("call reportRegister method start")
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        local luaoc = require "cocos.cocos2d.luaoc"
        local ok, ret = luaoc.callStaticMethod("XinstallLuaBridge","reportRegister")
        if not ok then
            print("luaoc reportRegister error:"..ret)
        end
    end
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
        local args = {}
        local signs = "()V"
        local ok,ret = luaj.callStaticMethod(activityClassName,"reportRegister",args,signs)
        if not ok then
            print("luaoc getInstallParam error:"..ret)
        end
    end  

    -- body
end

function xinstall:reportEventPoint(pointId,pointValue)
    print("call reportEffectPoint start")
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        local luaoc = require "cocos.cocos2d.luaoc"
        local args = {eventId = pointId, eventValue = pointValue}
        local ok, ret = luaoc.callStaticMethod("XinstallLuaBridge","reportEventPoint",args)
        if not ok then
            print("luaoc reportEffectPoint error:"..ret)
        end
    end
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
        local args = {pointId, pointValue}
        local signs = "(Ljava/lang/String;I)V"
        local ok,ret = luaj.callStaticMethod(activityClassName,"reportEventPoint",args,signs)
        if not ok then
            print("luaoc getInstallParam error:"..ret)
        end
    end 
    -- body
end

return xinstall
