package org.cocos2dx.lua;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.xinstall.XINConfiguration;
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

    private static boolean hasCallInit = false;
    private static boolean initialized = false;

    private static boolean isRegister = false;
    private static String wakeupDataHolder = null;
    private static int wakeUpLuaFunc = -1;

    private static Intent wakeupIntent = null;
    private static Activity wakeupActivity = null;

    public static void initNoAd(final Cocos2dxActivity cocos2dxActivity) {
        hasCallInit = true;
        XInstall.init(cocos2dxActivity);
		initialized(cocos2dxActivity);
    }

    public static void initWithAd(final int luaFunc,final boolean adEnable,final boolean isPermission,  String oaid,  String advertisingId, final Cocos2dxActivity cocos2dxActivity) {
        XINConfiguration configuration = XINConfiguration.Builder().adEnable(true);
        oaid = setNull(oaid);
        advertisingId = setNull(advertisingId);
        configuration.oaid(oaid);
        configuration.gaid(advertisingId);
        configuration.adEnable(adEnable);

        hasCallInit = true;

        Log.d("XinstallSDK", String.format("adEnabled = %s, oaid = %s, gaid = %s",
                true, oaid == null ? "NULL" : oaid, advertisingId == null ? "NULL" : advertisingId));
        if (isPermission) {
            XInstall.initWithPermission(cocos2dxActivity, configuration, new Runnable() {
                @Override
                public void run() {
                    initialized(cocos2dxActivity);
                    if (luaFunc != 0) {
                        cocos2dxActivity.runOnGLThread(new Runnable() {
                            @Override
                            public void run() {
                                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunc, "");
                            }
                        });
                    }
                }
            });
        } else {
            XInstall.init(cocos2dxActivity,configuration);
            initialized(cocos2dxActivity);
        }
    }

    private static String setNull(String res) {
        if (res == null || res.equalsIgnoreCase("null")
                || res.equalsIgnoreCase("undefined")) {
            return null;
        }
        return res;
    }

    public static void  setLog(boolean isOpen) {
        XInstall.setDebug(isOpen);
    }

    private static void initialized(final Cocos2dxActivity cocos2dxActivity) {
        initialized = true;
        if (wakeupIntent != null && wakeupActivity != null) {
            XInstall.getWakeUpParam(wakeupActivity, wakeupIntent, new XWakeUpAdapter() {
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
    }

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
        if (initialized) {
            XInstall.getWakeUpParam(cocos2dxActivity, intent, new XWakeUpAdapter() {
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
        } else {
            wakeupActivity = cocos2dxActivity;
            wakeupIntent = intent;
        }
    }

    public static void registerWakeupCallback(final int luaFunc, final Cocos2dxActivity cocos2dxActivity) {
        if (!hasCallInit) {
            Log.d(TAG,"未执行SDK 初始化方法, SDK 需要手动初始化(初始方法为 initNoAd 和 initWithAd !)");
            return;
        }
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
