import 'dart:async';

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
  void initSdk(String appId,String secretKey) {
    Map<String, dynamic> platformConfigMap = new Map();
    platformConfigMap[Constants.PLATFORM_CONFIG_APPID] = appId;
    platformConfigMap[Constants.PLATFORM_CONFIG_SECRET_KEY] = secretKey;
    _channel.invokeMethod('initSdk',platformConfigMap);
  }

  ///UI页面配置
  ///protocolText 自定义协议文案
  ///protocolUrl  自定义协议url
  Future<bool> setLoginUiConfig(String protocolText, String protocolUrl) {
    Map<String, dynamic> uiConfigMap = new Map();
    uiConfigMap[Constants.UI_CONFIG_PROTOCOL_TEXT_KEY] = protocolText;
    uiConfigMap[Constants.UI_CONFIG_PROTOCOL_URL_KEY] = protocolUrl;
    return _channel
        .invokeMethod('setLoginUiConfig', uiConfigMap)
        .then<bool>((isConfig) => isConfig);
  }

  ///UI页面配置
  ///loginThemeConfig 自定义协议文案配置
  Future<bool> setLoginThemeConfig(LoginThemeConfig loginThemeConfig) {
    return _channel
        .invokeMethod('setLoginThemeConfig', loginThemeConfig.toJson())
        .then<bool>((isConfig) => isConfig);
  }

  ///登陆
  Future<String> login() {
    return _channel
        .invokeMethod('login')
        .then<String>((loginResult) => loginResult);
  }
}
