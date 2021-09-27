# Xinstall-Lua-SDK 接入文档

> 【重要说明】：从 v1.5.0 版本（含）开始，调用  Xinstall 模块的任意方法前，必须先调用一次初始化方法（init 或者 initWithAd），否则将导致其他方法无法正常调用。
>
> 从 v1.5.0 以下升级到 v1.5.0 以上版本后，需要自行修改代码调用初始化方法，Xinstall 模块无法在升级后自动兼容。

## iOS 集成

### 一、添加 iOS 端文件

​		将 `LuaSDK/iOS` 目录下的 `XinstallCocos2dx_Lua` 文件夹拖入项目的 `ios` 目录，然后在弹窗框里，注意勾选**“Copy items if needed”**、**“Create groups”**

### 二、相关配置

#### 1. 初始化配置

 		在 [Xinstall官网](https://www.xinstall.com) 的管理后台中，创建对应 App 并记录 appKey 的值，然后在 Xcode 项目的 `Info.plist` 文件内添加如下配置：

```xml
<key>com.xinstall.APP_KEY</key>
<string>Xinstall创建的项目的AppKey,由Xinstall官网你的控制后台获得</string>
```

#### 2. 接入SDK

1. **在 Xcode 项目的 `AppController.mm` 文件夹中加入头文件** 

```objective-c
#import "XinstallCocos2dx_Lua/XinstallLuaSDK.h"
```

2. **配置 Universal links 关联域名**

   对于 iOS，为确保能正常使用一键拉起功能，AppID 必须开启 Associated Domains 功能，请到苹果开发者网站，选择 “Certificate, Identifiers & Profiles”，再选择 iOS 对应的 AppID，开启 Associated Domains：

   ![](res/1.png)

   开启 Associated Domains 功能后，需要创建**新的（或更新现有的）**描述文件，下载并导入到 Xcode 中（通过Xcode自动生成的描述文件，可跳过这一步）：

   ![](res/2.png)

   在 Xcode 中配置 Xinstall 为当前应用生成的关联域名 (Associated Domains) ：**applinks:xxxx.xinstall.top** 和 **applinks:xxxx.xinstall.net**

   > 具体的关联域名可在 Xinstall管理后台 - 对应的应用控制台 - iOS下载配置 页面中找到

   ![](res/3.png)

   配置完成后，需要在 `AppController.mm` 中添加 **Univeral Link** 相关的回调方法

   ```objective-c
   - (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
     //判断是否通过Xinstall Universal Link 唤起App
     if ([XinstallLuaSDK continueUserActivity:userActivity]){
       //如果使用了Universal link ，此方法必写
       return YES;
     }
     //其他第三方回调；
     return YES;
   }
   ```

3. **Scheme 配置**

   1. 在Xcode选中**Target** -> **Info** -> **URL Types**，配置**Xinstall** 为当前应用生成的 Scheme，如图所示：

      ![配置 scheme](https://doc.xinstall.com/integrationGuide/iOS6.png)

   2. 在 `AppController.mm` 中添加 **Scheme** 回调的方法

      ```objective-c
      // iOS9 以上会优先走这个方法
      - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
      	// 处理通过Xinstall URL SchemeURL 唤起App的数据
      	[XinstallSDK handleSchemeURL:url];
      	return YES;
      }
      
      // iOS9 以下调用这个方法
      - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
      	// 处理通过Xinstall URL SchemeURL 唤起App的数据
      	[XinstallSDK handleSchemeURL:url];
      	return YES;
      }
      ```

      

## Android平台配置

### 一、拷贝文件

1. 将Android目录下的两个java文件拷贝到`app/src`目录下
2. 将Android目录下的aar的包拷贝到项目的`app/libs`目录下

### 二、添加权限

在 `AndroidManifest.xml ` 中添加 **Xinstall** 需要的网络权限

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

### 三、配置AppKey和scheme

同样在 `AndroidManifest.xml` 中添加 标签

```xml
<meta-data android:name="com.xinstall.APP_KEY" android:value="Xinstall_APPKEY"/>
```

### 四、拉起配置

1. 将Cocos2dx项目中`AppActivity`继承 **Xinstall ** 提供的 **XInstallActivity**（就是前面拷贝的两个文件）

2. 在`AndroidManfest.xml`中给 `AppActivity` 添加 

   ```xml
   android:launchMode="singleTask"
   ```

   以及配置`scheme`

   ```xml
   <data android:scheme="xixxxxx"/>
   // 从Xinstall控制台获得scheme
   ```

   最后配置大致未

   ```xml
   <activity
               android:name="org.cocos2dx.lua.AppActivity"
               android:screenOrientation="landscape"
               android:configChanges="orientation|keyboardHidden|screenSize"
               android:label="@string/app_name"
               android:theme="@android:style/Theme.NoTitleBar.Fullscreen"
               android:launchMode="singleTask"
               android:taskAffinity=""  >
               <intent-filter>
                   <action android:name="android.intent.action.MAIN" />
                   <category android:name="android.intent.category.LAUNCHER" />
               </intent-filter>
               <intent-filter>
                   <action android:name="android.intent.action.VIEW"/>
                   <category android:name="android.intent.category.DEFAULT"/>
                   <category android:name="android.intent.category.BROWSABLE"/>
   
                   <data android:scheme="XINSTALL_SCHEME"/>
               </intent-filter>
   
   </activity>
   ```

   **注：** 如果不想继承Xinstall的Activity类，可以将Activity中的方法加到**AppActivity**里

## 模块使用指南

### 一、导入模块

导入 **xinstall.lua** 到文件工程中，并在调用的脚本里进行模块应引用：

```lua
--- require 内为文件地址，需要根据实际的文件地址进行更换
local xinstall = require("xinstall")
```

>  如果只是使用基础功能（无需携带参数安装、渠道统计、调起传参），不需要写任意代码，配置完成即可使用。

### 二、使用

> 注意：从 v1.5.0 版本开始，在调用 Xinstall 模块的任意方法之前，必须调用一次初始化方法，只需要调用一次即可，不需要反复调用。
>
> v1.5.0 之前的版本会在启动时自动初始化，无需调用，也无法调用。
>
> 从 v1.5.0 以下版本升级上来时，请注意去除原先原生代码中的初始化代码，改为调用模块提供的 JS 端初始化方法：
>
> * iOS 端请去除原生代码中的：`[XinstallLuaSDK init];`

调用 `init` 方法进行初始化：

```lua
local xinstall = require("xinstall")
xinstall:init()
```



#### 2. 携带参数安装

> 注意：调用该功能对应接口时需要在 Xinstall 中为对应 App 开通专业版服务

在 APP 需要安装参数时（在 web 中下载并安装 App 完成后，由 web 网页中传递过来的，如邀请码、游戏房间号等动态参数），调用 `getInstance` 接口，在回调中获取 web 中传递过来的参数。

```lua
local function getInstallCallBack(result)
    print("安装参数回调："..result)
end
// 注：第一个参数只对android 有效，为获取安装参数的超时时间
xinstall:getInstance(10, getInstallCallBack)
```

> 您可以在 Xinstall 管理后台对应的 App 内，看到所有的传递参数以及参数出现的次数，方便你们做运营统计分析，如通过该报表知道哪些页面或代理带来了最多客户，客户最感兴趣的 App 页面是什么等。具体参数名和值，运营人员可以和技术协商定义，或联系 Xinstall 客服咨询。具体效果如下图：
>
> ![传参报表](https://cdn.xinstall.com/iOS_SDK%E7%B4%A0%E6%9D%90/paramsTable.png)



#### 3. 拉起传参

> 注意：调用该功能对应接口时需要在 Xinstall 中为对应 App 开通专业版服务

在 App 需要唤醒参数时（手机已经安装 App 时，在 web 中直接通过 Universal Links / scheme 一键拉起 App），首先在 App 启动时预先调用 `registerWakeUpHandler` 或 `registerWakeUpDetailHandler` 接口添加监听，在回调中获取 web 中传递过来的参数。

在 Xinstall 模块初始化完成后，注册拉起事件的监听，在回调中获取拉起参数

> 您可以在下述两种回调方法中任选一个进行实现，不同的回调方法有不同的逻辑，请选择最符合您实际场景的方法进行实现，请勿同时实现两个方法。

**【方法一】：`registerWakeUpHandler()` 该方法只会在成功获取到拉起参数时，才会回调。如果无法成功获取到拉起参数，例如不是集成了 Xinstall Web SDK 的页面拉起您的 App 时，将会无法获取到拉起参数，也就不会执行该回调方法。**

```lua
local function wakeUpCallBack(result)
    print("拉起参数回调："..result)
end

xinstall:registerWakeUpHandler(wakeUpCallBack)
```

**【方法二】：`registerWakeUpDetailHandler()` 该方法无论是否成功获取到拉起参数，均会回调。如果成功获取到拉起参数，则 wakeUpData != {} 并且 error == {}；如果没有获取到拉起参数，则 wakeUpData == {} 并且 error != {}。**

```lua
local function wakeUpCallBack(result)
    print("拉起参数回调："..result)
end

xinstall:registerWakeUpDetailHandler(wakeUpCallBack)

// error.errorType 说明：
/** 
 * iOS
 * -1 : SDK 配置错误；
 * 0 : 未知错误；
 * 1 : 网络错误；
 * 2 : 没有获取到数据；
 * 3 : 该 App 已被 Xinstall 后台封禁；
 * 4 : 该操作不被允许（一般代表调用的方法没有开通权限）；
 * 5 : 入参不正确；
 * 6 : SDK 初始化未成功完成；
 * 7 : 没有通过 Xinstall Web SDK 集成的页面拉起；
 *
 * Android
 * 1006 : 未执行init 方法;
 * 1007 : 未传入Activity，Activity 未比传参数
 * 1008 : 用户未知操作 不处理
 * 1009 : 不是唤醒执行的调用方法
 * 1010 : 前后两次调起时间小于1s，请求过于频繁
 * 1011 : 获取调起参数失败
 * 1012 : 重复获取调起参数
 * 1013 : 本次调起并非为XInstall的调起
 * 1004 : 无权限
 * 1014 : SCHEME URL 为空
 */
```





#### 4. 渠道统计相关

##### 4.1 注册上报

在业务中合适的时机（一般指用户注册）调用指定方法上报注册量

```lua
xinstall:reportRegister()
```

**补充说明**

Xinstall 会自动完成安装量、留存率、活跃量、在线时长等渠道统计数据的上报工作，如需统计每个渠道的注册量（对评估渠道质量很重要），可根据自身的业务规则，在确保用户完成 App 注册的情况下，调用该方法上报后，即可在 Xinstall 平台即可看到注册量。



##### 4.2 事件点上报

事件统计，主要用来统计终端用户对于某些特殊业务的使用效果，如充值金额，分享次数，广告浏览次数等等。
调用接口前，需要先进入 Xinstall 管理后台**事件统计**然后点击新增事件。

```lua
// 第一个参数为事件ID，字符串类型
// 第二个参数为事件值，数字类型，必须为正整数
xinstall:reportEventPoint("123",25)
```

**补充说明**

只有 Xinstall 后台创建事件统计，并且代码中 **传递的事件ID** 与 **后台创建的ID** 一致时，上报数据才会被统计。



#### 5. 场景定制统计

场景业务介绍，可到[分享数据统计](https://doc.xinstall.com/environment/分享数据统计.html)页面查看

> 分享统计主要用来统计分享业务相关的数据，例如分享次数、分享查看人数、分享新增用户等。在用户分享操作触发后（注：此处为分享事件触发，非分享完成或成功），可调用如下方法上报一次分享数据：

```lua
xinstall:reportShareByXinShareId("填写分享人或UID")
```

**补充说明**

分享人或UID 可由您自行定义，只需要用以区分用户即可。

您可在 Xinstall 管理后台 对应 App 中查看详细分享数据报表，表中的「分享人/UID」即为调用方法时携带的参数，其余字段含义可将鼠标移到字段右边的小问号上进行查看：

![分享报表](https://doc.xinstall.com/integrationGuide/share.jpg)





#### 6. 广告平台渠道功能

> 如果您在 Xinstall 管理后台对应 App 中，**只使用「自建渠道」，而不使用「广告平台渠道」，则无需进行本小节中额外的集成工作**，也能正常使用 Xinstall 提供的其他功能。
>
> 注意：根据目前已有的各大主流广告平台的统计方式，目前 iOS 端和 Android 端均需要用户授权并获取一些设备关键值后才能正常进行 [ 广告平台渠道 ] 的统计，如 IDFA / OAID / GAID 等，对该行为敏感的 App 请慎重使用该功能。



##### 6.1 配置工作

**iOS 端：**

在 Xcode 中打开 iOS 端的工程，在 `Info.plist` 文件中配置一个权限作用声明（如果不配置将导致 App 启动后马上闪退）：

```xml
<key>NSUserTrackingUsageDescription</key>
<string>这里是针对获取 IDFA 的作用描述，请根据实际情况填写</string>
```

在 Xcode 中，找到 App 对应的「Target」，再点击「General」，然后在「Frameworks, Libraries, and Embedded Content」中，添加如下两个框架：

* AppTrackingTransparency.framework
* AdSupport.framework

**Android 端：**

相关接入可以参考广告平台联调指南中的[《Android集成指南》](https://doc.xinstall.com/AD/AndroidGuide.html)

1. 接入IMEI需要额外的全下申请，需要在`AndroidManifest`中添加权限声明

   ```java
   <uses-permission android:name="android.permission.READ_PHONE_STATE"/>
   ```

2. 如果使用OAID，因为内部使用反射获取oaid 参数，所以都需要外部用户接入OAID SDK 。具体接入参考[《Android集成指南》](https://doc.xinstall.com/AD/AndroidGuide.html)





##### 6.2、更换初始化方法

**使用新的 initWithAd 方法，替代原先的 init 方法来进行模块的初始化**

> iOS 端使用该方法时，需要传入 IDFA（在 Lua 脚本内）。您可以使用任意方式在 Lua 脚本中获取到 IDFA，例如第三方获取 IDFA 的模块。
>
> 如果您没有找到合适的第三方模块，您可以使用 Xinstall 提供的配套模块在 Lua 脚本内获取到 IDFA，再调用 initWithAd 方法进行初始化。配套插件在 **LuaSDK/Tool/IDFA 目录下**，以下代码示例均使用该模块进行说明

**入参说明**：需要主动传入参数，JSON对象

入参内部字段：

* iOS 端：
  | 参数名 | 参数类型 | 描述                   |
  | ------ | -------- | ---------------------- |
  | idfa   | 字符串   | iOS 系统中的广告标识符 |
  
* Android 端：

  | 参数名        | 参数类型 | 描述               |
  | ------------- | -------- | ------------------ |
  | adEnabled     | boolean  | 是否使用广告功能   |
  | oaid （可选） | string   | OAID               |
  | gaid（可选）  | string   | GaID(google Ad ID) |

  

**调用示例**

```lua
local xinstall = require("xinstall")
local idfa = require("idfa")

local function getIDFACallBack(result)
	print("getIDFACallBack："..result)
	xinstall:initWithAd({idfa = result})
end

local targetPlatform = cc.Application:getInstance():getTargetPlatform()
if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) then
  idfa:getIDFA(getIDFACallBack)
end
local function premissionEndCallBack() 
		print("执行了premissionEndCallBack")
		-- xinstall:getInstance 或者 xinstall:registerWakeUpHandler 等操作
end
if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
    -- oaid和gaid 为选传，不传则代表使用SDK自动去获取（SDK内不包括OAID SDK，需要自己接入）
    xinstall:initWithAd({adEnable = true,gaid = "gaid测试",oaid = "oaid测试"})
    -- 如果希望在完成初始化，立即执行之后的步骤可以通过 下列代码实现-------------------------
    -- xinstall:initWithAd({adEnable = true,gaid = "gaid测试",oaid = "oaid测试"},premissionEndCallBack)
    -- -----------------------------------------------------------------------------
end
```



##### 6.3、上架须知

**在使用了广告平台渠道后，若您的 App 需要上架，请认真阅读本段内容。**

##### 6.3.1 iOS 端：上架 App Store

1. 如果您的 App 没有接入苹果广告（即在 App 中显示苹果投放的广告），那么在提交审核时，在广告标识符中，请按照下图勾选：

![IDFA](https://cdn.xinstall.com/iOS_SDK%E7%B4%A0%E6%9D%90/IDFA_7.png)



1. 在 App Store Connect 对应 App —「App隐私」—「数据类型」选项中，需要选择：**“是，我们会从此 App 中收集数据”**：

![AppStore_IDFA_1](https://cdn.xinstall.com/iOS_SDK%E7%B4%A0%E6%9D%90/IDFA_1.png)

在下一步中，勾选「设备 ID」并点击【发布】按钮：

![AppStore_IDFA_2](https://cdn.xinstall.com/iOS_SDK%E7%B4%A0%E6%9D%90/IDFA_2.png)

点击【设置设备 ID】按钮后，在弹出的弹框中，根据实际情况进行勾选：

- 如果您仅仅是接入了 Xinstall 广告平台而使用了 IDFA，那么只需要勾选：**第三方广告**
- 如果您在接入 Xinstall 广告平台之外，还自行使用 IDFA 进行别的用途，那么在勾选 **第三方广告** 后，还需要您根据您的实际使用情况，进行其他选项的勾选

![AppStore_IDFA_3](https://cdn.xinstall.com/iOS_SDK%E7%B4%A0%E6%9D%90/IDFA_3.png)

![AppStore_IDFA_4](https://cdn.xinstall.com/iOS_SDK%E7%B4%A0%E6%9D%90/IDFA_4.png)

勾选完成后点击【下一步】按钮，在 **“从此 App 中收集的设备 ID 是否与用户身份关联？”** 选项中，请根据如下情况进行选择：

- 如果您仅仅是接入了 Xinstall 广告平台而使用了 IDFA，那么选择 **“否，从此 App 中收集的设备 ID 未与用户身份关联”**
- 如果您在接入 Xinstall 广告平台之外，还自行使用 IDFA 进行别的用途，那么请根据您的实际情况选择对应的选项

![AppStore_IDFA_5](https://cdn.xinstall.com/iOS_SDK%E7%B4%A0%E6%9D%90/IDFA_5.png)

最后，在弹出的弹框中，选择 **“是，我们会将设备 ID 用于追踪目的”**，并点击【发布】按钮：

![AppStore_IDFA_6](https://cdn.xinstall.com/iOS_SDK%E7%B4%A0%E6%9D%90/IDFA_6.png)

##### 6.3.2 Android 端

无特殊需要注意，如碰上相关合规问题，参考 [《应用合规指南》](https://doc.xinstall.com/应用合规指南.html)



## 导出apk/ipa包并上传

参考官网文档

[iOS集成-导出ipa包并上传](https://doc.xinstall.com/integrationGuide/iOSIntegrationGuide.html#四、导出ipa包并上传)

[Android-集成](https://doc.xinstall.com/integrationGuide/AndroidIntegrationGuide.html#四、导出apk包并上传)



## 如何测试功能

参考官方文档 [测试集成效果](https://doc.xinstall.com/integrationGuide/comfirm.html)



## 更多 Xinstall 进阶功能

若您想要自定义下载页面，或者查看数据报表等进阶功能，请移步 [Xinstall 官网](https://xinstall.com) 查看对应文档。

若您在集成过程中如有任何疑问或者困难，可以随时[联系 Xinstall 官方客服](https://admin.qidian.qq.com/template/blue/mp/menu/qr-code-jump.html?linkType=0&env=ol&kfuin=2355021609&fid=350&key=4576bf1f33461342433de54b612d61a0&cate=1&type=16&ftype=1&_type=wpa&qidian=true) 在线解决。





