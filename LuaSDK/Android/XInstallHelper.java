package org.cocos2dx.lua;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.xinstall.XINConfiguration;
import com.xinstall.XInstall;
import com.xinstall.listener.XInstallAdapter;
import com.xinstall.listener.XWakeUpAdapter;
import com.xinstall.model.XAppData;
import com.xinstall.model.XAppError;

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

    private static XAppData wakeUpData;
    private static XAppError wakeUpError;

    private static int wakeUpLuaFunc = -1;
    private static int wakeUpDetailLuaFunc = -1;

    private static Intent wakeupIntent = null;
    private static Activity wakeupActivity = null;

    public static Integer wakeupType = 0;

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
            if (wakeupType == 1) {
                XInstall.getWakeUpParam(wakeupActivity, wakeupIntent, new XWakeUpAdapter() {
                    @Override
                    public void onWakeUp(XAppData xAppData) {
                        if (!isRegister) {
                            Log.d(TAG, "wakeupCallback not register");
                            wakeUpData = xAppData;
                            wakeUpError = null;
                            return;
                        }

                        String jsonString = xAppData.toJsonObject().toString();
                        if (jsonString == null) {
                            jsonString = "";
                        }

                        Log.d(TAG, jsonString);

                        final String json = jsonString;

                        cocos2dxActivity.runOnGLThread(new Runnable() {
                            @Override
                            public void run() {
                                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(wakeUpLuaFunc, json);
                            }
                        });
                    }
                });
            } else {
                XInstall.getWakeUpParamEvenErrorAlsoCallBack(wakeupActivity, wakeupIntent, new XWakeUpAdapter() {
                    @Override
                    public void onWakeUpFinish(XAppData xAppData, XAppError xAppError) {
                        super.onWakeUpFinish(xAppData, xAppError);
                        if (!isRegister) {
                            Log.d(TAG, "wakeupCallback not register ");
                            wakeUpData = xAppData;
                            wakeUpError = xAppError;
                            return;
                        }

                        if (wakeupType == 2) {
                            String resultString = toJsonObjectHasErrorMap(xAppData,xAppError).toString();
                            if (resultString == null) {
                                resultString = "";
                            }
                            Log.d(TAG, resultString);
                            final String finalJsonString = resultString;
                            cocos2dxActivity.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    Cocos2dxLuaJavaBridge.callLuaFunctionWithString(wakeUpDetailLuaFunc, finalJsonString);
                                }
                            });
                        } else if (wakeupType == 1) {
                            String jsonString = xAppData.toJsonObject().toString();
                            if (jsonString == null) {
                                jsonString = "";
                            }

                            Log.d(TAG, jsonString);

                            final String finalJsonString = jsonString;
                            cocos2dxActivity.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    Cocos2dxLuaJavaBridge.callLuaFunctionWithString(wakeUpLuaFunc, finalJsonString);
                                }
                            });
                        }
                    }
                });
            }

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
            if (wakeupType == 1) {
                XInstall.getWakeUpParam(cocos2dxActivity, intent, new XWakeUpAdapter() {
                    @Override
                    public void onWakeUp(XAppData xAppData) {
                        if (!isRegister) {
                            Log.d(TAG, "wakeupCallback not register");
                            wakeUpData = xAppData;
                            wakeUpError = null;
                            return;
                        }

                        String jsonString = xAppData.toJsonObject().toString();
                        if (jsonString == null) {
                            jsonString = "";
                        }

                        Log.d(TAG, jsonString);

                        final String json = jsonString;

                        cocos2dxActivity.runOnGLThread(new Runnable() {
                            @Override
                            public void run() {
                                Cocos2dxLuaJavaBridge.callLuaFunctionWithString(wakeUpLuaFunc, json);
                            }
                        });
                    }
                });
            } else {
                XInstall.getWakeUpParamEvenErrorAlsoCallBack(cocos2dxActivity, intent, new XWakeUpAdapter() {
                    @Override
                    public void onWakeUpFinish(XAppData xAppData, XAppError xAppError) {
                        super.onWakeUpFinish(xAppData, xAppError);
                        if (!isRegister) {
                            Log.d(TAG, "wakeupCallback not register ");
                            wakeUpData = xAppData;
                            wakeUpError = null;
                            return;
                        }

                        if (wakeupType == 2) {
                            String resultString = toJsonObjectHasErrorMap(xAppData,xAppError).toString();
                            if (resultString == null) {
                                resultString = "";
                            }
                            Log.d(TAG, resultString);
                            final String finalJsonString = resultString;
                            cocos2dxActivity.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    Cocos2dxLuaJavaBridge.callLuaFunctionWithString(wakeUpDetailLuaFunc, finalJsonString);
                                }
                            });
                        } else if (wakeupType == 1) {
                            String jsonString = xAppData.toJsonObject().toString();
                            if (jsonString == null) {
                                jsonString = "";
                            }

                            Log.d(TAG, jsonString);

                            final String finalJsonString = jsonString;
                            cocos2dxActivity.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    Cocos2dxLuaJavaBridge.callLuaFunctionWithString(wakeUpLuaFunc, finalJsonString);
                                }
                            });
                        }
                    }
                });
            }

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

        if (wakeupType == 2) {
            Log.d(TAG, "registerWakeupCallback 与 registerWakeupDetailCallback 为互斥方法，择一选择使用");
        }
        wakeupType = 1;

        isRegister = true;
        wakeUpLuaFunc = luaFunc;

        if (wakeUpData != null) {
            Log.d(TAG, "wakeupDataHolder = " + (wakeUpData.toJsonObject() != null ? wakeUpData.toJsonObject().toString():"null"));
            cocos2dxActivity.runOnGLThread(new Runnable() {
                @Override
                public void run() {
                    Cocos2dxLuaJavaBridge.callLuaFunctionWithString(wakeUpLuaFunc, wakeUpData.toJsonObject().toString());
                    wakeUpData = null;
                    wakeUpError = null;
                }
            });
        }
    }

    public static void registerWakeupDetailCallback(final int luaFunc, final Cocos2dxActivity cocos2dxActivity) {
        if (!hasCallInit) {
            Log.d(TAG,"未执行SDK 初始化方法, SDK 需要手动初始化(初始方法为 initNoAd 和 initWithAd !)");
            return;
        }

        if (wakeupType == 1) {
            Log.d(TAG, "registerWakeupCallback 与 registerWakeupDetailCallback 为互斥方法，择一选择使用");
        }
        wakeupType = 2;

        isRegister = true;
        wakeUpDetailLuaFunc = luaFunc;

        if (wakeUpData != null || wakeUpError != null) {

            cocos2dxActivity.runOnGLThread(new Runnable() {
                @Override
                public void run() {
                    JSONObject result = toJsonObjectHasErrorMap(wakeUpData, wakeUpError);
                    Log.d(TAG, "wakeupDataHolder = " + result.toString());
                    Cocos2dxLuaJavaBridge.callLuaFunctionWithString(wakeUpDetailLuaFunc, result.toString());
                    wakeUpData = null;
                    wakeUpError = null;
                }
            });
        }
    }

    private static JSONObject toJsonObjectHasErrorMap(XAppData data, XAppError xAppError) {
        JSONObject wakeUpData = new JSONObject();
        if (data != null) {
            wakeUpData = data.toJsonObject();
        }

        JSONObject error = new JSONObject();
        if (xAppError != null) {
            try {
                error.put("errorType",xAppError.getErrorCode());
                error.put("errorMsg",xAppError.getErrorMsg());
            } catch (Exception e) {

            }
        }
        JSONObject result = new JSONObject();
        try {
            result.put("wakeUpData",wakeUpData);
            result.put("error",error);
        } catch (Exception e) {

        }

        return  result;
    }
}
