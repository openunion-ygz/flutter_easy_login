package com.opun.flutter_easy_login;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.util.Log;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import cn.emay.ql.LoginCallback;
import cn.emay.ql.UniSDK;
import cn.emay.ql.utils.LoginUiConfig;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;


public class FlutterEasyLoginPlugin implements MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {

  private static final String TAG = "FlutterEasyLoginPlugin";
  private static final String NAMESPACE = "flutter_easy_login";
  private final PluginRegistry.Registrar registrar;
  private final Activity activity;
  private final MethodChannel channel;
  private MethodChannel.Result mResult;
  public static final int REQUEST_CODE_PERMISSION = 200;
  private LoginUiConfig mLoginUiConfig;
  private boolean isPermissionGrand = false;

  /**
   * Plugin registration.
   */
  public static void registerWith(PluginRegistry.Registrar registrar) {
    final FlutterEasyLoginPlugin instance = new FlutterEasyLoginPlugin(registrar);
    registrar.addRequestPermissionsResultListener(instance);


  }

  FlutterEasyLoginPlugin(PluginRegistry.Registrar r) {
    this.registrar = r;
    this.activity = r.activity();
    this.channel = new MethodChannel(registrar.messenger(), NAMESPACE + "/methods");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    mResult = result;
    switch (call.method){
      case "getPlatformVersion":{
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      }
      case "initSdk":{
        String version = UniSDK.getInstance().getVersion();
        result.success(requestPermission());
        break;
      }
      case "setLoginUiConfig":{
        String protocolText = call.argument(Constants.PARAM_KEY_PROTOCOL_TEXT);
        String protocolUrl = call.argument(Constants.PARAM_KEY_PROTOCOL_URL);
        result.success(setLoginUiConfig(protocolText,protocolUrl));
        break;
      }

      case "login":{
        if (getLoginUiConfig() != null){
          if (isPermissionGrand){
            UniSDK.getInstance().login(activity.getApplication(), Constants.APP_ID, Constants.SECRET_KEY, new LoginCallback() {
              @Override
              public void onSuccess(String s) {
                Log.e(TAG,s);
                result.success(s);
              }

              @Override
              public void onFailed(String s) {
                Log.e(TAG,s);
//                result.success(s);
              }
            },getLoginUiConfig());
          }else {
              requestPermission();
          }
        }else {
          Toast.makeText(activity.getApplication(),"配置错误",Toast.LENGTH_SHORT).show();
        }
        break;
      }

      default:
        result.notImplemented();
        break;
    }
  }
  //权限检查申请
  private boolean requestPermission() {
    //读取手机权限
    int phoneStatePermission = ContextCompat.checkSelfPermission(activity.getApplicationContext(), Manifest.permission.READ_PHONE_STATE);
    //权限已经申请
    if (phoneStatePermission == PackageManager.PERMISSION_GRANTED) {
      isPermissionGrand = true;
      return true;
    } else {
      //权限未申请
      ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.READ_PHONE_STATE}, REQUEST_CODE_PERMISSION);
      isPermissionGrand = false;
      return false;
    }

  }
  private boolean setLoginUiConfig(String protocolText, String protocolUrl) {
    LoginUiConfig uiConfig = new LoginUiConfig();
    LoginUiConfig.YiDongLoginConfig yidongConfig = uiConfig.new YiDongLoginConfig();
    yidongConfig.setLoginLogo("logo");
    yidongConfig.setProtocolText("用户自定义协议");
    yidongConfig.setProtocolUrl("http://www.baidu.com");
    yidongConfig.setShowOtherLogin(false);
    uiConfig.setYiDongLoginConfig(yidongConfig);

    LoginUiConfig.LianTongLoginConfig lianTongLoginConfig = uiConfig.new LianTongLoginConfig();
    lianTongLoginConfig.setLoginLogo(R.drawable.logo);

    lianTongLoginConfig.setProtocolText("用户自定义协议");
    lianTongLoginConfig.setProtocolUrl("http://www.baidu.com");
    lianTongLoginConfig.setShowOtherLogin(false);
    uiConfig.setLianTongLoginConfig(lianTongLoginConfig);

    LoginUiConfig.DianXinLoginConfig dianXinLoginConfig = uiConfig.new DianXinLoginConfig();
    dianXinLoginConfig.setLoginLogo(R.drawable.logo);

    dianXinLoginConfig.setProtocolText("用户自定义协议");
    dianXinLoginConfig.setProtocolUrl("http://www.baidu.com");
    dianXinLoginConfig.setShowOtherLogin(false);
    uiConfig.setDianXinLoginConfig(dianXinLoginConfig);
    mLoginUiConfig = uiConfig;
    return true;
  }

  private LoginUiConfig getLoginUiConfig(){
    return mLoginUiConfig;
  }

  @Override
  public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    if (requestCode == REQUEST_CODE_PERMISSION) {
      //用户同意权限申请
      if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
        isPermissionGrand = true;
      }else {
        //用户拒绝权限
        isPermissionGrand = false;
        requestPermission();
      }
    }
    return false;
  }
}
