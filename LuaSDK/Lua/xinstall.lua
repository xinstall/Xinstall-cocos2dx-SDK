local targetPlatform = cc.Application:getInstance():getTargetPlatform()

-- "org/cocos2dx/lua/AppActivity" 为项目AppActivity的package加类名
local activityClassName = "org/cocos2dx/lua/AppActivity"

local xinstall = class("xinstall")

function xinstall:setLog(isOpen)
    print("call setLog method start")
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        local luaoc = require "cocos.cocos2d.luaoc"
        local args = {isOpen = isOpen}
        local ok, ret = luaoc.callStaticMethod("XinstallLuaBridge", "setShowLog", args)
        if not ok then
            print("luaoc setLog error:"..ret)
        end
    end
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
        local args = {isOpen}
        local signs = "(Z)V"
        local ok,ret = luaj.callStaticMethod(activityClassName,"setLog",args,signs)
        if not ok then
            print("luaoc setLog error:"..ret)
        end
    end
end

function xinstall:init()
    print("call init method start")
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        local luaoc = require "cocos.cocos2d.luaoc"
        local ok, ret = luaoc.callStaticMethod("XinstallLuaBridge", "init")
        if not ok then
            print("luaoc init error:"..ret)
        end
    end
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
        local args = {}
        local signs = "()V"
        local ok,ret = luaj.callStaticMethod(activityClassName,"initNoAd",args,signs)
        if not ok then
            print("luaoc init error:"..ret)
        end
    end
end

function xinstall:initWithAd(params, premissionCallback)
    print("call init method start")
    
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        print(params.idfa)
        local luaoc = require "cocos.cocos2d.luaoc"
        local ok, ret = luaoc.callStaticMethod("XinstallLuaBridge", "initWithAd", params)
        if not ok then
            print("luaoc init error:"..ret)
        end
    end
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
        
        -- 是否开启网络权限
        local adEnable = params.adEnable
        if (adEnable == null) then
            adEnable = true
            print("adEnable 为必填参数！")
        end
        
        local oaid = params.oaid
        if (oaid == null) then
            oaid = "";
        end
        local gaid = params.gaid
        if (gaid == null) then
            gaid = "";
        end
        
        -- 是否内部处理权限
        local isPremission = params.isPremission
        if (isPremission == null) then
            isPremission = true
        end
        
        if (premissionCallback == null) then
            premissionCallback = 0
        end
        
        -- print("isPremission"..isPremission.."adEnable"..adEnable.."oaid"..oaid.."gaid"..gaid)
        local args = {premissionCallback,adEnable,isPremission,oaid,gaid}
        local signs = "(IZZLjava/lang/String;Ljava/lang/String;)V"
        local ok,ret = luaj.callStaticMethod(activityClassName,"initWithAd",args,signs)
        if not ok then
            print("luaoc getInstallParam error:"..ret)
        end
    end

end

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
end

function xinstall:registerWakeUpDetailHandler(callback)
    print("call registerWakeUpDetailHandler method start")
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        local luaoc = require "cocos.cocos2d.luaoc"
        local args = {functionId = callback}
        local ok, ret = luaoc.callStaticMethod("XinstallLuaBridge","registerWakeUpDetailHandler",args)
        if not ok then
            print("luaoc registerWakeUpDetailHandler error:"..ret)
        end
    end
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
        local args = {callback}
        local signs = "(I)V"
        local ok,ret = luaj.callStaticMethod(activityClassName,"registerWakeupDetailCallback",args,signs)
        if not ok then
            print("luaoc getInstallParam error:"..ret)
        end
    end
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
end

function xinstall:reportShareByXinShareId(xinShareId)
    print("call reportShareByXinShareId start")
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
        local luaoc = require "cocos.cocos2d.luaoc"
        local args = {xinShareId = xinShareId}
        local ok, ret = luaoc.callStaticMethod("XinstallLuaBridge","reportShareByXinShareId",args)
        if not ok then
            print("luaoc reportShareByXinShareId error:"..ret)
        end
    end
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        local luaj = require "cocos.cocos2d.luaj"
        local args = {xinShareId}
        local signs = "(Ljava/lang/String;)V"
        local ok,ret = luaj.callStaticMethod(activityClassName,"reportShareByXinShareId",args,signs)
        if not ok then
            print("luaoc getInstallParam error:"..ret)
        end
    end
end

return xinstall
