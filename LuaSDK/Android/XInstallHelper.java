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
                final String json = toJson(xAppData);
                Log.d(TAG, json);
                cocos2dxActivity.runOnGLThread(new Runnable() {
                    @Override
                    public void run() {
                        Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunc, json);
                        Cocos2dxLuaJavaBridge.releaseLuaFunction(luaFunc);
                    }
                });
            }

        });
    }

    public static void getWakeUpParam(Intent intent, final Cocos2dxActivity cocos2dxActivity) {
        XInstall.getWakeUpParam(intent, new XWakeUpAdapter() {
            @Override
            public void onWakeUp(XAppData xAppData) {
                final String json = toJson(xAppData);
                Log.d(TAG, json);
                
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

    private static String toJson(XAppData xAppData) {
        JSONObject jsonObject = new JSONObject();

        try {
            jsonObject.put("channelCode", xAppData.getChannelCode());

            //获取数据
            Map<String, String> data = xAppData.getExtraData();
            //通过链接后面携带的参数或者通过webSdk初始化传入的data值。
            String uo = data.get("uo");
            //webSdk初始，在buttonId里面定义的按钮点击携带数据
            String co = data.get("co");
            String timeSpan = xAppData.getTimeSpan();
            Boolean firstFetch = xAppData.getFirstFetch();
            
            jsonObject.put("uo", uo);
            jsonObject.put("co", co);
            jsonObject.put("timeSpan", timeSpan);
            jsonObject.put("firstFetch",firstFetch);
            
            
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

}
