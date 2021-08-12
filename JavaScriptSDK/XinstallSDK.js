var xinstall = {
	wakeupCallback: function(appData) {

	},

	installCallback: function(appData) {

	},
	
	premissionSuccessCallback: function() {
		
	},

	_installCallback: function(appData) {
		if(this.installCallback != null) {
			this.installCallback(appData);
		}
	},

	_wakeupCallback: function(appData) {
		if(this.wakeupCallback != null) {
			this.wakeupCallback(appData);
		}
	},
	
	_premissionCallback: function() {
		if(this.premissionCallback != null) {
			this.premissionCallback()
		}
	},
	

	setLog: function(isOpen) {
		if (cc.sys.OS_ANDROID == cc.sys.os) {
			jsb.reflection.callStaticMethod("org/cocos2dx/javascript/AppActivity",
			"setLog", "(Z)V",isOpen);
		} else if (cc.sys.OS_IOS == cc.sys.os) {
			jsb.reflection.callStaticMethod("XinstallJSBridge", "setShowLog:", isOpen);
		}
	},


	// 手动初始化SDK
	init: function() {
		if (cc.sys.OS_ANDROID == cc.sys.os) {
			jsb.reflection.callStaticMethod("org/cocos2dx/javascript/AppActivity",
			"initNoAd", "()V");
		} else if (cc.sys.OS_IOS == cc.sys.os) {
			jsb.reflection.callStaticMethod("XinstallJSBridge", "init");
		}
	},

	initWithAd: function(params,premissionCallback) {
		this.premissionCallback = premissionCallback;
		if (cc.sys.OS_ANDROID == cc.sys.os) {
			var adEnabled = params.adEnabled;
			var oaid = params.oaid;
			var gaid = params.gaid;
			var isNeedImeiPremission = params.needImeiPremission;

			cc.log("adEnabled = " + adEnabled + ", oaid = " + oaid +", gaid = " + gaid);
			if (oaid == null || oaid == undefined) {
				oaid = "";
			}
			if (gaid == null || gaid == undefined) {
				gaid = "";
			}
			if (isNeedImeiPremission == null || isNeedImeiPremission == undefined ) {
				// 默认需要
				isNeedImeiPremission = true;
			}

			jsb.reflection.callStaticMethod("org/cocos2dx/javascript/AppActivity",
			    "initWithAd", "(ZZLjava/lang/String;Ljava/lang/String;)V",adEnabled,isNeedImeiPremission,oaid,gaid);
		} else if (cc.sys.OS_IOS == cc.sys.os) {
			var idfa = params.idfa;
			cc.log("idfa = " + idfa);
			if (idfa == null || idfa == undefined) {
				idfa = "";
			}
			jsb.reflection.callStaticMethod("XinstallJSBridge", "initWithAd:", idfa);
		}
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
};

module.exports = xinstall;
