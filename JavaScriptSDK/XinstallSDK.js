var xinstall = {
	wakeupCallback: function(appData) {

	},

	installCallback: function(appData) {

	},

	getInstallParams: function(s, callback) {
		this.installCallback = callback;
		if (cc.sys.OS_IOS == cc.sys.os) {
			// iOS 平台 
			// iOS 平台未外曝timeout设置方法
			jsb.reflection.callStaticMethod("XinstallJSBridge","getInstallParams");
		} else if (cc.sys.OS_ANDROID == cc.sys.os) {
			// 安卓平台
			jsb.reflection.callStaticMethod("org/cocos2dx/javascript/AppActivity",
                "getInstallParams", "(I)V", s);
		}
 
	},

	registerWakeUpHandler: function(callback) {
		this.wakeupCallback = callback;
		if (cc.sys.OS_IOS == cc.sys.os) {
			// iOS 平台
			jsb.reflection.callStaticMethod("XinstallJSBridge","registerWakeUpHandler");
		} else if (cc.sys.OS_ANDROID == cc.sys.os) {
			jsb.reflection.callStaticMethod("org/cocos2dx/javascript/AppActivity",
                "registerWakeUpHandler", "()V");
		}
	},

	reportRegister: function() {
		if (cc.sys.OS_IOS == cc.sys.os) {
			// iOS 平台
			jsb.reflection.callStaticMethod("XinstallJSBridge","reportRegister");
		} else if (cc.sys.OS_ANDROID == cc.sys.os) {
			// 安卓平台
			jsb.reflection.callStaticMethod("org/cocos2dx/javascript/AppActivity",
                "reportRegister", "()V");
		}
	},

	reportEvent: function(eventId, eventValue) {
		if (cc.sys.OS_IOS == cc.sys.os) {
			// iOS 平台
			jsb.reflection.callStaticMethod("XinstallJSBridge","reportEventId:eventValue:",eventId,eventValue);
		} else if (cc.sys.OS_ANDROID == cc.sys.os) {
			// 安卓平台
			jsb.reflection.callStaticMethod("org/cocos2dx/javascript/AppActivity",
                "reportEvent","(Ljava/lang/String;I)V",eventId,eventValue);
		}
	},

	_installCallback: function(appData) {
		this.installCallback(appData);
	},
	
	_wakeupCallback: function(appData) {
		this.wakeupCallback(appData);
	},
};

module.exports = xinstall;