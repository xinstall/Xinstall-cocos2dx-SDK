package org.cocos2dx.lua;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import com.xinstall.XInstall;

import org.cocos2dx.HelloWorld.R;
import org.cocos2dx.lib.Cocos2dxActivity;

public class XInstallActivity extends Cocos2dxActivity {

    private static Cocos2dxActivity cocos2dxActivity = null;
    private static final Handler UIHandler = new Handler(Looper.getMainLooper());

    private  static void runInUIThread(Runnable runnable) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            // 当前线程为UI主线程
            runnable.run();
        } else {
            UIHandler.post(runnable);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        cocos2dxActivity = this;
        XInstallHelper.getWakeUpParam(getIntent(), cocos2dxActivity);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        XInstallHelper.getWakeUpParam(intent, cocos2dxActivity);
    }

    public static void  setLog(final boolean isOpen) {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                XInstallHelper.setLog(isOpen);
            }
        });
    }

    public static void initNoAd() {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                XInstallHelper.initNoAd(cocos2dxActivity);
            }
        });
    }

    public static void initWithAd(final int luaFunc,final boolean adEnable,final boolean imeiPermission, final String oaid, final String advertisingId) {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                XInstallHelper.initWithAd( luaFunc,adEnable, imeiPermission, oaid, advertisingId, cocos2dxActivity);
            }
        });
    }

    public static void getInstallParam(final int s, final int luaFunc) {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                XInstallHelper.getInstallParam(s, luaFunc, cocos2dxActivity);
            }
        });
    }

    public static void registerWakeupCallback(final int luaFunc){
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                XInstallHelper.registerWakeupCallback(luaFunc, cocos2dxActivity);
            }
        });
    }

    public static void registerWakeupDetailCallback(final  int luaFunc) {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                XInstallHelper.registerWakeupDetailCallback(luaFunc, cocos2dxActivity);
            }
        });
    }

    public static void reportEventPoint(final String eventId, final int eventValue){
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                XInstall.reportEvent(eventId, eventValue);
            }
        });

    }

    public static void reportShareByXinShareId(final String userId) {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                XInstall.reportShareByXinShareId(userId);
            }
        });
    }

    public static void reportRegister() {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                XInstall.reportRegister();
            }
        });
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        // 将权限请求结果告知 Xinstall
        XInstall.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

}
