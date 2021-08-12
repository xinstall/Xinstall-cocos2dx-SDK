var idfaTool = {
	getIDFACallback: function(idfa) {

	},

	getIDFA: function(callback) {
		this.getIDFACallback = callback;
		if (cc.sys.OS_IOS == cc.sys.os) {
			// iOS 平台
			jsb.reflection.callStaticMethod("IDFAJSBridge","getIDFA");
		}
	},

	_getIDFACallback: function(idfaObj) {
		this.getIDFACallback(idfaObj.idfa);
	},
};

module.exports = idfaTool;
