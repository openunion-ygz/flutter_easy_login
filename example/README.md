# flutter_easy_login_example

Demonstrates how to use the flutter_easy_login plugin.

## Getting Started

## Android

一、概述

    该插件是根据亿美提供的sdk、android及ios分别在对应的原生平台进行集成、flutter再通过对应的通道方法进行调用，

    实现亿美一键登录功能的插件。目前仅集成android平台，IOS在后续更新中...

二、使用流程

    1.根据向亿美提供的包名创建flutter工程（如：在亿美后台申请的应用包名为“com.opun.xxx”，则需要创建工程名为该名称，

    只有应用包名与亿美后台对应，后台才能识别签名）；

    2.在flutter的pubspec.yaml文件中添加插件的git依赖：

     flutter_easy_login:
        git:
          url: https://github.com/yiguozhen0510/flutter_easy_login.git

     3.在flutter项目的android项目中添加配置：

     application中添加：“tools:replace="android:label"”

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

    5.最后，编译运行即可

三、api介绍

    1.插件的初始化：

    FlutterEasyLogin.instance.initSdk();

    调用该方法主要是申请读取手机的权限，会返回一个布尔值，以此来判断读取手机的权限是否已经申请成功。需要注意的是：

    该方法必须在最开始调用，申请对应的权限。

    2.设置移动、电信、联通三大运营商一键登录UI页面：

    FlutterEasyLogin.instance.setLoginUiConfig('自定义协议', 'http://www.baidu.com');

    由于集成的sdk内部对于三大运营商的一键登录UI设计标准已经做了部分封装，相同的UI已经集成，而我们需要做的，仅仅是

    设置一个公司或者应用对应的协议文案及协议跳转的url，因此，只需要传入两个参数：公司规定的自定义协议文案、协议调跳转的url。

    注意：(1)如果需要设置自定义的文案，则需要在调用登录方法之前调用该方法，否则UI样式为默认的样式

         (2)自定义文案及协议也可以不设置，不设置，则为默认的UI样式

         (3)默认的UI样式已经可以满足三大运营商的一键登录UI设计标准

    3.登录方法：

    FlutterEasyLogin.instance.login();

    若登录成功，则该方法会返回一个加密的手机号字符串，获取到加密的手机号字符串之后，可以根据业务逻辑需求进行对应的操作。


##=========================================================================================================

## IOS