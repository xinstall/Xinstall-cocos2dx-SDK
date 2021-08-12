package com.xinstall.cocos2dx;


import android.content.Intent;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import com.xinstall.XInstall;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxGLSurfaceView;


public class XinstallCocos2dxJSActivity extends Cocos2dxActivity {

    private static  XinstallCocos2dxJSActivity app = null;
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
        app = this;
        // 需要调用wakeup
        XinstallCocos2dxJSHelper.getWakeupParams(getIntent(),app);
    }

    @Override
    public Cocos2dxGLSurfaceView onCreateView() {
        Cocos2dxGLSurfaceView glSurfaceView = new Cocos2dxGLSurfaceView(this);
        // TestCpp should create stencil buffer
        glSurfaceView.setEGLConfigChooser(5, 6, 5, 0, 16, 8);

        return glSurfaceView;
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        // 需要调用wakeup
        XinstallCocos2dxJSHelper.getWakeupParams(intent,app);
    }

    public static void  setLog(final boolean isOpen) {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                XinstallCocos2dxJSHelper.setLog(isOpen,app);
            }
        });
    }

    public static void initNoAd() {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                XinstallCocos2dxJSHelper.initNoAd(app);
            }
        });
    }

    public static void initWithAd(final boolean adEnable,final boolean imeiPermission, final String oaid, final String advertisingId) {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                XinstallCocos2dxJSHelper.initWithAd(adEnable,imeiPermission,oaid,advertisingId,app);
            }
        });
    }

    public  static void getInstallParams(final int s) {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                // 调用SDK 安装参数获取
                XinstallCocos2dxJSHelper.getInstallParams(s,app);
            }
        });
    }

    public static  void registerWakeUpHandler() {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                // 调用SDK 获取调起参数
                XinstallCocos2dxJSHelper.registerWakeupCallback(app);
            }
        });
    }

    public static void reportRegister() {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                // 调用SDK 进行注册上报
                XInstall.reportRegister();
            }
        });
    }

    public static void reportEvent(final String eventId, final int eventValue) {
        runInUIThread(new Runnable() {
            @Override
            public void run() {
                // 调用SDK 进行事件上报
                XInstall.reportPoint(eventId, eventValue);
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
