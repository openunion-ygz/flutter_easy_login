import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_easy_login/constants.dart';

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

  ///sdk初始化（手机权限申请）
  void initSdk() {
    _channel.invokeMethod('initSdk');
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

  ///登陆
  Future<String> login() {
    return _channel
        .invokeMethod('login')
        .then<String>((loginResult) => loginResult);
  }
}
