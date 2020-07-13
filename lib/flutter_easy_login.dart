import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_easy_login/constants.dart';
import 'package:flutter_easy_login/login_theme_config.dart';

class FlutterEasyLogin {
  static const MethodChannel _channel =
      const MethodChannel('${Constants.NAMESPACE}/methods');
  final StreamController<MethodCall> _methodStreamController =
      new StreamController.broadcast();

  Stream<MethodCall> get _methodStream => _methodStreamController.stream;

//登录结果json串的键
  static const String LOGIN_RESULT_KEY = "login_result";
  static const String LOGIN_DATA_KEY = "login_data";

  FlutterEasyLogin._() {
    _channel.setMethodCallHandler((MethodCall call) {
      _methodStreamController.add(call);
    });
  }

  static FlutterEasyLogin _instance = new FlutterEasyLogin._();

  static FlutterEasyLogin get instance => _instance;

  ///sdk初始化
  /// android:手机权限申请
  /// android ios 设置亿美平台相关参数信息，如： appid等
  void initSdk(String appId, String secretKey) {
    if (Platform.isAndroid) {
      Map<String, dynamic> platformConfigMap = new Map();
      platformConfigMap[Constants.PLATFORM_CONFIG_APPID] = appId;
      platformConfigMap[Constants.PLATFORM_CONFIG_SECRET_KEY] = secretKey;
      _channel.invokeMethod('initSdk', platformConfigMap);
    }
  }

  ///UI页面配置
  ///protocolText 自定义协议文案
  ///protocolUrl  自定义协议url
  Future<bool> setLoginUiConfig(String protocolText, String protocolUrl) {
    Map<String, dynamic> uiConfigMap = new Map();
    uiConfigMap[Constants.UI_CONFIG_PROTOCOL_TEXT_KEY] = protocolText;
    uiConfigMap[Constants.UI_CONFIG_PROTOCOL_URL_KEY] = protocolUrl;
    if (Platform.isAndroid) {
      return _channel
          .invokeMethod('setLoginUiConfig', uiConfigMap)
          .then<bool>((isConfig) => isConfig);
    } else {
      return new Future(() {
        return true;
      });
    }
  }

  ///UI页面配置
  ///loginThemeConfig 自定义协议文案配置
  Future<bool> setLoginThemeConfig(LoginThemeConfig loginThemeConfig) {
    if (Platform.isAndroid) {
      return _channel
          .invokeMethod('setLoginThemeConfig', loginThemeConfig.toJson())
          .then<bool>((isConfig) => isConfig);
    } else {
      return new Future(() {
        return true;
      });
    }
  }

  ///登陆
  Future<String> login() {
    if (Platform.isAndroid) {
      return _channel
          .invokeMethod('login')
          .then<String>((loginResult) => loginResult);
    } else if (Platform.isIOS) {
      //IOS平台暂时不支持一键登录，处理成其他登录方式的情形
      Map<String, dynamic> result = new Map();
      result['login_result'] = 'false';
      result['login_data'] = 'otherWayLogin';
      return new Future(() {
        return json.encode(result);
      });
    } else {
      Map<String, dynamic> result = new Map();
      result['login_result'] = 'false';
      result['login_data'] = 'notImplemented...';
      return new Future(() {
        return json.encode(result);
      });
    }
  }

//统一处理用户取消登录及“其他登录方式”的回调
//  String handleUserCancelAndOtherWayLogin(String loginResult) {
//    if (Platform.isAndroid) {
//    } else if (Platform.isIOS) {
//    } else {}
//    return "";
//  }
}
