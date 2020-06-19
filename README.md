# flutter_easy_login

A EasyLogin Flutter plugin.

## Getting Started

## Android

一、概述

    该插件是根据亿美提供的sdk、android及ios分别在对应的原生平台进行集成、flutter再通过对应的通道方法进行调用，

    实现亿美一键登录功能的插件。目前仅集成android平台,IOS在后续更新中...

二、使用流程

    1.根据向亿美提供的包名创建flutter工程（如：在亿美后台申请的应用包名为“com.opun.xxx”，则需要创建工程名为该名称，

    只有应用包名与亿美后台对应，后台才能识别签名）；

    2.在flutter的pubspec.yaml文件中添加插件的git依赖：

     flutter_easy_login:
        git:
          url: https://github.com/openunion-ygz/flutter_easy_login.git

     3.在flutter项目的android项目中添加配置：

     application中添加：“tools:replace="android:allowBackup,android:label"”,同时，在根节点声明：" xmlns:tools="http://schemas.android.com/tools""

     4.android工程下的gradle文件中添加签名信息：（注意：在android{}中，同时，根据签名文件的位置对应修改路径 “storeFile file”）

         //亿美一键登录配置
         signingConfigs {
             //默认情况下，运行项目编译的时候，是debug模式，无法正常使用我们指定的签名文件，因此，如果需要使用我们指定的签名文件，就需要添加对应的debug配置
             //或者手动使用我们指定的签名文件打包
             debug {
                 keyAlias '...'
                 keyPassword '...'
                 storeFile file('../xxx.keystore')
                 storePassword '...'
             }

             release {
                 keyAlias '...'
                 keyPassword '...'
                 storeFile file('../xxx.keystore')
                 storePassword '...'
             }
         }

    5.将example项目下的drawable/ct_account_min_dialog.xml,layout下的联通及电信xml登录授权页面xml文件，values的文件进行合并

    （假如文件不存在，则直接拷贝，存在则合并），需要注意的是：移动不能通过xml的形式修改登录授权页面样式，只有联通及电信可以修改部分

    通过xml文件修改部分页面样式，同时，不允许删除xml中的任何元素，只能修改其样式；另外联通及电信的部分样式，需要通过代码设置，具体

    设置，详见以下说明及demo；

    6.最后，编译运行即可

三、api介绍

    1.插件的初始化：

    FlutterEasyLogin.instance.initSdk(String appId,String secretKey);

    1)调用该方法主要是申请读取手机的权限，权限申请成功之后，为登录方法读取手机状态做准备。需要注意的是：

    该方法必须在最开始调用，申请对应的权限;

    2)同时，该方法需要传入appid等平台参数进行初始化。

    2.设置移动、电信、联通三大运营商一键登录UI页面：

    (1)移动授权登录页面UI只能通过代码的形式设置；

    (2)电信及联通的部分UI样式可以在xml中修改(注意：仅部分UI可以在对应的xml文件中修改，同时，xml中不可增删控件，只能修改样式)；

    (3)电信及联通授权登录页面样式除了可以在对应的xml中设置之外，也可以通过代码的形式设置(具体设置参考demo)

    (4)默认的UI样式已经可以满足三大运营商的一键登录UI设计标准，因此如无特殊要求，使用默认UI样式即可；

    (5)设置授权页面logo(Android) 说明:

      需要在 Android 项目下 res/drawable 中添加相关的 png 图片资源 图片资源的名称与配置对应，如上面的显示logo配置 logoImgPath : 'cafa_logo', 对应

      res/drawable/cafa_logo.png,即logo的命名需要与setLoginUiConfig()中设置logo时传入的参数一致；

    (6)设置页面UI的方式：

    FlutterEasyLogin.instance.setLoginThemeConfig(LoginThemeConfig loginThemeConfig);

    该方法中，只需要传入参数自定义的UI样式即可

    (7)自定义授权页面属性：

    导航栏：
    navCustom //导航栏是否隐藏
    navColor //导航栏颜色
    navText //导航栏文字
    navReturnImgPath //导航栏返回图标icon路径

    logo：
    logoImgPath //logo路径
    logoWidth //logo宽
    logoHeight //logo高

    登录按钮：
    logBtnText //登录按钮文本
    logBtnHeight //登录按钮高度(必须大于40)

    协议：
    appFPrivacyText //开发者隐私条款协议名称1
    appFPrivacyUr //开发者隐私条款协议1 url
    appSPrivacyText //开发者隐私条款协议名称2
    appSPrivacyUrl //开发者隐私条款协议2 url
    privacyColor //隐私条款协议颜色

    otherWayLogin//是否显示其他登录方式（默认显示，其中，电信运营商不可控制隐藏及显示，其规定必须显示；

    其他登录方式的回调在回调的 fail中）

    3.登录方法：

    FlutterEasyLogin.instance.login();

    若登录成功，则该方法会得到一个json字符串，包含登录成功与否的结果与主要的信息。若登录成功，

    则可得到加密的手机号字符串，获取到加密的手机号字符串之后，可以根据业务逻辑需求进行对应的操作；

    若登录失败，则返回登录失败的主要信息。

    注意：得到返回结果字符串之后，根据规定的键进行取值，即：

    返回结果：

    {"login_result":"false","login_data":"登录失败 ： 应用与密钥信息不匹配"}

    根据键取值：

       Map<String, dynamic> map = json.decode(loginResult);
       String isLoginSuccessStr = map[FlutterEasyLogin.LOGIN_RESULT_KEY];
       String loginResult = map[FlutterEasyLogin.LOGIN_DATA_KEY];

       其中，FlutterEasyLogin.LOGIN_RESULT_KEY,FlutterEasyLogin.LOGIN_DATA_KEY 为固定的键

       4.用户主动取消的回调在login()方法中返回，根据运营商的不同，返回码分别为：

       移动:200020

       联通:101007

       电信:80200

       最后，在login()回调方法中，对应的标识为：Constants.USER_CANCEL_STATE

       5.“其他登录方式”：默认显示，若需要显示并使用，则可通过setLoginThemeConfig()方法进行设置；同时，其回到也可以通过

       login()方法得到，根据不同的运营商，其返回码分别为：

        移动:

        联通:

        电信:80201

        最后，在login()回调方法中，对应的标识为：Constants.OTHER_WAY_LOGIN

        6.关于是否显示“其他登录方式”的说明：

        联通-->需要在引入的xml文件中动态修改隐藏及显示

        电信-->电信运营商规定必须显示

        移动-->可通过setLoginThemeConfig()方法进行设置


## 四、注意事项：

    1.由于Flutter插件开发的需要，本插件中的example/android工程的包名并不是亿美一键登录后台的对应的包名，因此在运行example/android项目时，

    无法登陆成功，会出现“应用包名与签名信息不符”问题，因此，使用时需要根据包名另外创建新的flutter工程，再引用本插件;

    2.关于登录页面的logo图片设置：修改logo，通过在主工程下的Android或者ios目录中分别放入需要设置的logo图片，同时，通过setLoginUiConfig

    方法设置与logo相同命名的属性即可

##=========================================================================================

## IOS

       1.用户主动取消的回调在login()方法中返回，返回码为：CANCLE_LOGIN，同时，login()方法的回调中，标识为： Constants.USER_CANCEL_STATE

       2.“其他登录方式”：默认显示，若需要显示并使用，则可通过setLoginThemeConfig()方法进行设置；同时，其回到也可以通过

       login()方法得到，其返回码为：CHANGE_LOGIN_TYPE，同时，login()方法的回调中，标识为：Constants.OTHER_WAY_LOGIN

