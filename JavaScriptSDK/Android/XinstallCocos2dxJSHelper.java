package com.xinstall.cocos2dx;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.xinstall.XINConfiguration;
import com.xinstall.XInstall;
import com.xinstall.listener.XInstallAdapter;
import com.xinstall.listener.XWakeUpAdapter;
import com.xinstall.listener.XWakeUpListener;
import com.xinstall.model.XAppData;
import com.xinstall.model.XAppError;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxJavascriptJavaBridge;
import org.json.JSONObject;

public class XinstallCocos2dxJSHelper {
    private static final String SELFNAME = "XinCocos2dxJSHelper";
    // 是否有注册wake
    private static  boolean registerWakeup = false;
    private static XAppData wakeUpData;
    private static XAppError wakeUpError;

    private static boolean hasCallInit = false;
    private static boolean initialized = false;

    private static Intent wakeupIntent = null;
    private static Activity wakeupActivity = null;

    public static Integer wakeupType = 0;

//    private static String REQUIRE_XINSTALL = "var xinstall = require(\"XinstallSDK\");";
    //如果无法成功回调 高版本Cocos Creator构建的项目请使用下方语句
     private static String REQUIRE_XINSTALL = "var xinstall = window.__require(\"XinstallSDK\");";
    private static String CALLBACK_PATTERN = "xinstall.%s(%s);";
    private static String CALLBACK_NODATA_PATTERN = "xinstall.%s();";
    private static String CALLBACK_INSTALL = "_installCallback";
    private static String CALLBACK_WAKEUP = "_wakeupCallback";
    private static String CALLBACK_WAKEUP_DETAIL = "_wakeupDetailCallback";
    private static String CALLBACK_PREMISSINO = "_premissionCallback";


    public static void initNoAd(final Cocos2dxActivity cocos2dxActivity) {
        hasCallInit = true;
        XInstall.init(cocos2dxActivity);
        initialized(cocos2dxActivity);
    }

    public static void initWithAd(final boolean adEnable,final boolean isPermission,  String oaid,  String advertisingId, final Cocos2dxActivity cocos2dxActivity) {
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
                    cocos2dxActivity.runOnGLThread(new Runnable() {
                        @Override
                        public void run() {
                            callback(CALLBACK_PREMISSINO, null);
                        }
                    });
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

    private static void initialized(final Cocos2dxActivity cocos2dxActivity) {
        initialized = true;
        if (wakeupIntent != null && wakeupActivity != null) {
            if (wakeupType == 1) {
                XInstall.getWakeUpParam(wakeupActivity, wakeupIntent, new XWakeUpAdapter() {
                    @Override
                    public void onWakeUp(XAppData xAppData) {
                        if ( xAppData != null) {
                            if (!registerWakeup) {
                                Log.d(SELFNAME, "没有注册 wakeupCallback");
                                wakeUpData = xAppData;
                                wakeUpError = null;
                                return;
                            }
                            String jsonString = xAppData.toJsonObject().toString();
                            if (jsonString == null) {
                                jsonString = "";
                            }
                            Log.d(SELFNAME,"wakeUpData = " + jsonString);
                            final String finalJsonString = jsonString;
                            cocos2dxActivity.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    callback(CALLBACK_WAKEUP, finalJsonString);
                                }
                            });
                        }
                    }
                });
            } else {
                XInstall.getWakeUpParamEvenErrorAlsoCallBack(wakeupActivity, wakeupIntent, new XWakeUpAdapter() {
                    @Override
                    public void onWakeUpFinish(XAppData xAppData, XAppError xAppError) {
                        super.onWakeUpFinish(xAppData, xAppError);
                        if (!registerWakeup) {
                            Log.d(SELFNAME, "没有注册 wakeupCallback");
                            wakeUpData = xAppData;
                            wakeUpError = xAppError;
                            return;
                        }

                        if (wakeupType == 2) {
                            JSONObject result = toJsonObjectHasErrorMap(xAppData,xAppError);
                            String resultString = result.toString();
                            if (resultString == null) {
                                resultString = "";
                            }
                            Log.d(SELFNAME,"wakeupData = " + resultString);
                            final String finalResultString = resultString;
                            cocos2dxActivity.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    callback(CALLBACK_WAKEUP_DETAIL, finalResultString);
                                }
                            });
                        } else {
                            String resultString = xAppData.toJsonObject().toString();
                            if (resultString == null) {
                                resultString = "";
                            }
                            Log.d(SELFNAME, resultString);
                            final String finalJsonString = resultString;
                            cocos2dxActivity.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    callback(CALLBACK_WAKEUP, finalJsonString);
                                    wakeUpData = null;
                                    wakeUpError = null;
                                }
                            });
                        }

                    }
                });
            }

        }
    }

    public static void  setLog(final boolean isOpen,final  Cocos2dxActivity cocos2dxActivity) {
        cocos2dxActivity.runOnGLThread(new Runnable() {
            @Override
            public void run() {
                XInstall.setDebug(isOpen);
            }
        });
    }

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
        if (initialized) {
            if (wakeupType == 1) {
                XInstall.getWakeUpParam(cocos2dxActivity, intent, new XWakeUpAdapter() {
                    @Override
                    public void onWakeUp(XAppData xAppData) {

                        if (!registerWakeup) {
                            Log.d(SELFNAME, "没有注册 wakeupCallback");
                            wakeUpData = xAppData;
                            wakeUpError = null;
                            return;
                        }

                        String jsonString = xAppData.toJsonObject().toString();
                        if (jsonString == null) {
                            jsonString = "";
                        }
                        Log.d(SELFNAME, jsonString);

                        final String finalJsonString = jsonString;

                        cocos2dxActivity.runOnGLThread(new Runnable() {
                            @Override
                            public void run() {
                                callback(CALLBACK_WAKEUP, finalJsonString);
                                wakeUpData = null;
                                wakeUpError = null;
                            }
                        });
                    }
                });
            } else {
                XInstall.getWakeUpParamEvenErrorAlsoCallBack(cocos2dxActivity, intent, new XWakeUpAdapter() {
                    @Override
                    public void onWakeUpFinish(XAppData xAppData, XAppError xAppError) {
                        super.onWakeUpFinish(xAppData, xAppError);
                        if (!registerWakeup) {
                            Log.d(SELFNAME, "没有注册 wakeupCallback");
                            wakeUpData = xAppData;
                            wakeUpError = xAppError;
                            return;
                        }

                        if (wakeupType == 2) {
                            String resultString = toJsonObjectHasErrorMap(xAppData,xAppError).toString();
                            if (resultString == null) {
                                resultString = "";
                            }
                            Log.d(SELFNAME, resultString);
                            final String finalJsonString = resultString;
                            cocos2dxActivity.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    callback(CALLBACK_WAKEUP_DETAIL, finalJsonString);
                                    wakeUpData = null;
                                    wakeUpError = null;
                                }
                            });
                        } else if (wakeupType == 1){
                            String resultString = xAppData.toJsonObject().toString();
                            if (resultString == null) {
                                resultString = "";
                            }
                            Log.d(SELFNAME, resultString);
                            final String finalJsonString = resultString;
                            cocos2dxActivity.runOnGLThread(new Runnable() {
                                @Override
                                public void run() {
                                    callback(CALLBACK_WAKEUP, finalJsonString);
                                    wakeUpData = null;
                                    wakeUpError = null;
                                }
                            });
                        }

                    }
                });
            }

        } else {
            wakeupIntent = intent;
            wakeupActivity = cocos2dxActivity;
        }

    }

    public static void registerWakeupCallback(final  Cocos2dxActivity cocos2dxActivity) {
        if (!hasCallInit) {
            Log.d(SELFNAME,"未执行SDK 初始化方法, SDK 需要手动初始化(初始方法为 initNoAd 和 initWithAd !)");
            return;
        }

        if (wakeupType == 2) {
            Log.d(SELFNAME, "registerWakeupCallback 与 registerWakeupDetailCallback 为互斥方法，择一选择使用");
        }
        wakeupType = 1;
        registerWakeup = true;

        if (wakeUpData != null) {
            Log.d(SELFNAME,"wakeUpDataJsonString = " + wakeUpData.toJsonObject().toString());
            final String resultString = wakeUpData.toJsonObject().toString();
            cocos2dxActivity.runOnGLThread(new Runnable() {
                                               @Override
                                               public void run() {
                                                   callback(CALLBACK_WAKEUP,resultString);
                                                   wakeUpError = null;
                                                   wakeUpData = null;
                                               }
                                           }
            );
        }
    }

    public static void registerWakeupDetailCallback(final  Cocos2dxActivity cocos2dxActivity) {
        if (!hasCallInit) {
            Log.d(SELFNAME,"未执行SDK 初始化方法, SDK 需要手动初始化(初始方法为 initNoAd 和 initWithAd !)");
            return;
        }

        if (wakeupType == 1) {
            Log.d(SELFNAME, "registerWakeupCallback 与 registerWakeupDetailCallback 为互斥方法，择一选择使用");
        }
        wakeupType = 2;
        registerWakeup = true;

        if (wakeUpData != null || wakeUpError != null) {
            JSONObject result = toJsonObjectHasErrorMap(wakeUpData,wakeUpError);
            Log.d(SELFNAME,"wakeUpDataJsonString = " + result.toString());
            final String finalResultString = result.toString();
            cocos2dxActivity.runOnGLThread(new Runnable() {
                                               @Override
                                               public void run() {
                                                   callback(CALLBACK_WAKEUP_DETAIL,finalResultString);
                                                   wakeUpData = null;
                                                   wakeUpError = null;
                                               }
                                           }
            );
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

    @SuppressLint("LongLogTag")
    private static void callback(String method, String data) {
        String evalStr;
        if (data == null) {
            evalStr = REQUIRE_XINSTALL + String.format(CALLBACK_NODATA_PATTERN, method);
        } else {
            evalStr = REQUIRE_XINSTALL + String.format(CALLBACK_PATTERN, method, data);
        }

        Log.d(SELFNAME, evalStr);
        Cocos2dxJavascriptJavaBridge.evalString(evalStr);
    }
}
