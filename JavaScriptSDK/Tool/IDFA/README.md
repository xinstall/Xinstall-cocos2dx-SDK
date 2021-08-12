# IDFATool 使用指南

> IDFATool 是针对 iOS 平台获取广告标识值（IDFA）的工具，可直接在 Cocos2d-x JS 引擎的 JS 脚本内进行调用。
>
> 目前已适配最新的 iOS 15 版本。由于 iOS 14 开始，苹果强制要求获取 IDFA 时，需要使用 `AppTrackingTransparency` 框架，而该框架必须在 Xcode 12 及以上版本中，才能使用，所以建议将 Xcode 版本升级至 12 或者更新版本，否则将导致 iOS 14 以上版本无法获取到 IDFA。

### 一、集成方法

1. 在 CocosCreate 编辑器中，导入 IDFATool.js 文件

2. 使用 Xcode 打开构建后的 iOS 工程，拖入以下4个文件：

   * IDFAJSBridge.h
   * IDFAJSBridge.mm
   * IDFAJSDelegate.h
   * IDFAJSDelegate.mm

3. 在 Xcode 中，找到 App 对应的「Target」，再点击「General」，然后在「Frameworks, Libraries, and Embedded Content」中，添加如下两个框架：

   * AppTrackingTransparency.framework
   * AdSupport.framework

4. 在 iOS 工程的 Info.plist 文件中，加入获取 IDFA 的权限声明（不加的话，打开 App 会直接闪退）：

   ```xml
   <key>NSUserTrackingUsageDescription</key>
   <string>这里是针对获取 IDFA 的作用描述，请根据实际情况填写</string>
   ```

   

### 二、调用方法

在游戏脚本中，可以按如下代码方式调用，来获取 IDFA ：

```javascript
var idfaTool = require("IDFATool");

idfaTool.getIDFA(function(idfa) {
  cc.log('IDFA：'+ idfa);
});
```

