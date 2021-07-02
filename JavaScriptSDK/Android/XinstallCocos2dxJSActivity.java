package com.xinstall.cocos2dx;

import android.content.Intent;
import android.os.Bundle;

import com.xinstall.XInstall;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxGLSurfaceView;


public class XinstallCocos2dxJSActivity extends Cocos2dxActivity {
    private static  XinstallCocos2dxJSActivity app = null;

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

    public  static void getInstallParams(int s) {
        // 调用SDK 安装参数获取
        XinstallCocos2dxJSHelper.getInstallParams(s,app);
    }

    public static  void registerWakeUpHandler() {
        // 调用SDK 获取调起参数
        XinstallCocos2dxJSHelper.registerWakeupCallback(app);
    }

    public static void reportRegister() {
        // 调用SDK 进行注册上报
        XInstall.reportRegister();
    }

    public static void reportEvent(String eventId, int eventValue) {
        // 调用SDK 进行事件上报
        XInstall.reportPoint(eventId, eventValue);
    }
}
