local targetPlatform = cc.Application:getInstance():getTargetPlatform()

local idfa = class("idfa")

function idfa:getIDFA(callback)
    print("call idfa method start")
	if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
		local luaoc = require "cocos.cocos2d.luaoc"
        local args = {functionId = callback}
        local ok, ret = luaoc.callStaticMethod("IDFALuaBridge","getIDFA", args)
        if not ok then
            print("luaoc getIDFA error:"..ret)
        end
    end
	-- body
end

return idfa
