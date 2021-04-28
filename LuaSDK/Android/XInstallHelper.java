package org.cocos2dx.lua_tests;

import android.content.Intent;
import android.util.Log;

import com.xinstall.XInstall;
import com.xinstall.listener.XInstallAdapter;
import com.xinstall.listener.XWakeUpAdapter;
import com.xinstall.model.XAppData;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;

/**
 * Created by snow on 2020/12/9.
 */
public class XInstallHelper {

    private static final String TAG = "XInstallHelper";
    private static boolean isRegister = false;
    private static String wakeupDataHolder = null;
    private static int wakeUpLuaFunc = -1;

    public static void getInstallParam(int timeuot, final int luaFunc, final Cocos2dxActivity cocos2dxActivity) {

        XInstall.getInstallParam(new XInstallAdapter() {
            @Override
            public void onInstall(XAppData xAppData) {
				if (xAppData != null) {
					String jsonString = xAppData.toJsonObject().toString();
					if (jsonString == null) {
					    jsonString = "";
					}
					
					Log.d(TAG, jsonString);
					final String json = jsonString;
					
					cocos2dxActivity.runOnGLThread(new Runnable() {
					    @Override
					    public void run() {
					        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunc, json);
					        Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFunc);
					    }
					});
				}
            }

        });
    }

    public static void getWakeUpParam(Intent intent, final Cocos2dxActivity cocos2dxActivity) {
        XInstall.getWakeUpParam(intent, new XWakeUpAdapter() {
            @Override
            public void onWakeUp(XAppData xAppData) {
                String jsonString = xAppData.toJsonObject().toString();
                if (jsonString == null) {
                    jsonString = "";
                }
                
                Log.d(TAG, jsonString);
				
                final String json = jsonString;
				
                if (!isRegister) {
                    Log.d(TAG, "wakeupCallback not register , wakeupData = " + json);
                    wakeupDataHolder = json;
                    return;
                }
                cocos2dxActivity.runOnGLThread(new Runnable() {
                    @Override
                    public void run() {
                        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(wakeUpLuaFunc, json);
                    }
                });
            }
        });
    }

    public static void registerWakeupCallback(final int luaFunc, final Cocos2dxActivity cocos2dxActivity) {
        isRegister = true;
        wakeUpLuaFunc = luaFunc;
        if (wakeupDataHolder != null) {
            Log.d(TAG, "wakeupDataHolder = " + wakeupDataHolder);
            cocos2dxActivity.runOnGLThread(new Runnable() {
                @Override
                public void run() {
                    Cocos2dxLuaJavaBridge.callLuaFunctionWithString(wakeUpLuaFunc, wakeupDataHolder);
                    wakeupDataHolder = null;
                }
            });
        }
    }
}
