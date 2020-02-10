import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_easy_login/constants.dart';

class FlutterEasyLogin {
  static const MethodChannel _channel =
  const MethodChannel('${Constants.NAMESPACE}/methods');
  final StreamController<MethodCall> _methodStreamController =
  new StreamController.broadcast();
  Stream<MethodCall> get _methodStream => _methodStreamController.stream;

  FlutterEasyLogin._() {
    _channel.setMethodCallHandler((MethodCall call) {
      _methodStreamController.add(call);
    });
  }

  static FlutterEasyLogin _instance = new FlutterEasyLogin._();

  static FlutterEasyLogin get instance => _instance;
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
///sdk初始化
  Future<bool> initSdk(){
    return _channel.invokeMethod('initSdk')
        .then<bool>((isSucc) => isSucc);
}
///UI页面配置
  Future<bool>  setLoginUiConfig(String protocolText,String protocolUrl){
    Map<String, dynamic> uiConfigMap = new Map();
    uiConfigMap['protocolText'] = protocolText;
    uiConfigMap['protocolUrl'] = protocolUrl;
    return _channel.invokeMethod('setLoginUiConfig',uiConfigMap)
        .then<bool>((isConfig) => isConfig);
}

Future<String> login(){
    return _channel.invokeMethod('login')
        .then<String>((phoneNumStr) => phoneNumStr);
}
}
