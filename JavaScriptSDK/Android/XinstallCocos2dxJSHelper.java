package com.xinstall.cocos2dx;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.util.Log;

import com.xinstall.XInstall;
import com.xinstall.listener.XInstallAdapter;
import com.xinstall.listener.XInstallListener;
import com.xinstall.listener.XWakeUpAdapter;
import com.xinstall.model.XAppData;
import com.xinstall.model.XAppError;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxJavascriptJavaBridge;

public class XinstallCocos2dxJSHelper {
    private static final String SELFNAME = "XinstallCocos2dxJSHelper";
    // 是否有注册wake
    private static  boolean registerWakeup = false;
    private static String wakeUpDataJsonString;

    private static String REQUIRE_XINSTALL = "var xinstall = require(\"XinstallSDK\");";
    //如果无法成功回调 高版本Cocos Creator构建的项目请使用下方语句
    // private static String REQUIRE_XINSTALL = "var xinstall = window.__require(\"XinstallSDK\");";
    private static String CALLBACK_PATTERN = "xinstall.%s(%s);";
    private static String CALLBACK_INSTALL = "_installCallback";
    private static String CALLBACK_WAKEUP = "_wakeupCallback";

    public static void getInstallParams(int s, final Cocos2dxActivity cocos2dxActivity) {
        XInstall.getInstallParam(new XInstallAdapter() {
            @Override
            public void onInstall(XAppData xAppData) {
                if ( xAppData != null) {
                    String jsonString = xAppData.toJsonObject().toString();
                    if (jsonString == null) {
                        jsonString = "";
                    }
                    Log.d(SELFNAME,"installData = " + jsonString);
                    final String finalJsonString = jsonString;
                    cocos2dxActivity.runOnGLThread(new Runnable() {
                        @Override
                        public void run() {
                            callback(CALLBACK_INSTALL, finalJsonString);
                        }
                    });
                }
            }
        });
    }

    public static  void getWakeupParams(Intent intent, final  Cocos2dxActivity cocos2dxActivity) {
        XInstall.getWakeUpParam(intent, new XWakeUpAdapter() {
            @Override
            public void onWakeUp(XAppData xAppData) {
                String jsonString = xAppData.toJsonObject().toString();
                if (jsonString == null) {
                    jsonString = "";
                }
                Log.d(SELFNAME,jsonString);
                if (!registerWakeup) {
                    Log.d(SELFNAME,"没有注册 wakeupCallback");
                    wakeUpDataJsonString = jsonString;
                    return;
                }
                final String finalJsonString = jsonString;
                cocos2dxActivity.runOnGLThread(new Runnable() {
                    @Override
                    public void run() {
                        callback(CALLBACK_WAKEUP,finalJsonString);
                        wakeUpDataJsonString = null;
                    }
                });

            }
        });
    }

    public static void registerWakeupCallback(final  Cocos2dxActivity cocos2dxActivity) {
        registerWakeup = true;
        if (wakeUpDataJsonString != null) {
            Log.d(SELFNAME,"wakeUpDataJsonString = " + wakeUpDataJsonString);
            cocos2dxActivity.runOnGLThread(new Runnable() {
                                               @Override
                                               public void run() {
                                                   callback(CALLBACK_WAKEUP,wakeUpDataJsonString);
                                                   wakeUpDataJsonString = null;
                                               }
                                           }
            );
        }
    }

    @SuppressLint("LongLogTag")
    private static void callback(String method, String data) {
        String evalStr = REQUIRE_XINSTALL + String.format(CALLBACK_PATTERN, method, data);
        Log.d(SELFNAME, evalStr);
        Cocos2dxJavascriptJavaBridge.evalString(evalStr);
    }
}
