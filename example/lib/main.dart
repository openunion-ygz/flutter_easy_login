import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_easy_login/flutter_easy_login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _phoneNum = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await FlutterEasyLogin.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
//      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(child: Text('亿美一键登录初始化'),
                  onPressed: (){
                    FlutterEasyLogin.instance.initSdk();
                    FlutterEasyLogin.instance.setLoginUiConfig('自定义协议', 'http://www.baidu.com');
                  }),
              RaisedButton(child: Text('亿美一键登录测试'),
                onPressed: (){
                  FlutterEasyLogin.instance.login().then((phoneNum){
                    print('phoneNum  ===> $phoneNum');
                    setState(() {
                      _phoneNum = phoneNum;
                    });
                  });
                },
              ),
              Text(
                '亿美一键登录返回结果:',
              ),
              Text(
                '$_phoneNum',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
