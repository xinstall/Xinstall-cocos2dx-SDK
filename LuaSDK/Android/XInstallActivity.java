package org.cocos2dx.lua_tests; 

import android.content.Intent;
import android.os.Bundle;

import com.xinstall.XInstall;

import org.cocos2dx.lib.Cocos2dxActivity;

public class XInstallActivity extends Cocos2dxActivity {

    private static Cocos2dxActivity cocos2dxActivity = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        cocos2dxActivity = this;
        XInstall.init(this);
        XInstallHelper.getWakeUpParam(getIntent(), cocos2dxActivity);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);

        XInstallHelper.getWakeUpParam(intent, cocos2dxActivity);
    }

    public static void getInstallParam(int s, int luaFunc) {
        XInstallHelper.getInstallParam(s, luaFunc, cocos2dxActivity);
    }

    public static void registerWakeupCallback(int luaFunc){
        XInstallHelper.registerWakeupCallback(luaFunc, cocos2dxActivity);
    }

    public static void reportEventPoint(String eventId, int eventValue){
        XInstall.reportPoint(eventId, eventValue);
    }

    public static void reportRegister() {
        XInstall.reportRegister();
    }

}
