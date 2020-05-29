package com.opun.flutter_easy_login;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.alibaba.fastjson.JSON;

import java.util.HashMap;
import java.util.Map;

import cn.com.chinatelecom.account.sdk.AuthPageConfig;
import cn.emay.ql.LoginCallback;
import cn.emay.ql.UniSDK;
import cn.emay.ql.utils.DeviceUtil;
import cn.emay.ql.utils.LoginUiConfig;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;


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
    private boolean isLogin = false;

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
        switch (call.method) {

            case "initSdk": {
                String version = UniSDK.getInstance().getVersion();
                requestPermission();
                result.success(null);
                break;
            }
            case "setLoginUiConfig": {
                String protocolText = call.argument(Constants.PARAM_KEY_PROTOCOL_TEXT);
                String protocolUrl = call.argument(Constants.PARAM_KEY_PROTOCOL_URL);
                Log.e("protocolText===>", protocolText);
                Log.e("protocolUrl===>", protocolUrl);
                result.success(setLoginUiConfig(protocolText, protocolUrl));
                break;
            }

            case "login": {
                int phoneStatePermission = ContextCompat.checkSelfPermission(activity.getApplicationContext(), Manifest.permission.READ_PHONE_STATE);
                if (phoneStatePermission == PackageManager.PERMISSION_GRANTED) {
                    if (getLoginUiConfig() != null) {
                        login(result);
                    } else {
                        setLoginUiConfig("", "");
                        login(result);
                    }
                } else {
                    requestPermission();
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
//      isPermissionGrand = true;
            return true;
        } else {
            //权限未申请
            ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.READ_PHONE_STATE}, REQUEST_CODE_PERMISSION);
//      isPermissionGrand = false;
            return false;
        }

    }

    private boolean setLoginUiConfig(String protocolText, String protocolUrl) {
        /*
        if (TextUtils.isEmpty(protocolText) || TextUtils.isEmpty(protocolUrl)) {
            protocolText = Constants.PROTOCOL_TEXT_DEFAULT;
            protocolUrl = Constants.PROTOCOL_URL_DEFAULT;
        }
        LoginUiConfig uiConfig = new LoginUiConfig();
        LoginUiConfig.YiDongLoginConfig yidongConfig = uiConfig.new YiDongLoginConfig();
        yidongConfig.setLoginLogo("logo");
        yidongConfig.setProtocolText(protocolText);
        yidongConfig.setProtocolUrl(protocolUrl);
        yidongConfig.setShowOtherLogin(false);
        uiConfig.setYiDongLoginConfig(yidongConfig);

        LoginUiConfig.LianTongLoginConfig lianTongLoginConfig = uiConfig.new LianTongLoginConfig();
        lianTongLoginConfig.setLoginLogo(R.drawable.logo);

        lianTongLoginConfig.setProtocolText(protocolText);
        lianTongLoginConfig.setProtocolUrl(protocolUrl);
        lianTongLoginConfig.setShowOtherLogin(false);
        uiConfig.setLianTongLoginConfig(lianTongLoginConfig);

        LoginUiConfig.DianXinLoginConfig dianXinLoginConfig = uiConfig.new DianXinLoginConfig();
        dianXinLoginConfig.setLoginLogo(R.drawable.logo);

        dianXinLoginConfig.setProtocolText(protocolText);
        dianXinLoginConfig.setProtocolUrl(protocolUrl);
        dianXinLoginConfig.setShowOtherLogin(false);
        uiConfig.setDianXinLoginConfig(dianXinLoginConfig);
        mLoginUiConfig = uiConfig;
        */

        LoginUiConfig uiConfig = new LoginUiConfig();
        LoginUiConfig.YiDongLoginConfig yidongConfig = uiConfig.new YiDongLoginConfig();

        yidongConfig.setStatusBarColor(0xff0086d0);
        yidongConfig.setAuthNavTransparent(false);//授权页head是否隐藏
        yidongConfig.setAuthBGImgPath("");//设置背景图
        yidongConfig.setNavColor(0xff0086d0);//导航栏颜色
        yidongConfig.setNavReturnImgPath("");//导航返回图标
        yidongConfig.setNavReturnSize(30);//返回图标大小
        yidongConfig.setNavText("登录");//导航栏标题
        yidongConfig.setNavTextColor(0xffffffff);//导航栏字体颜色
        yidongConfig.setNavTextSize(17);

        yidongConfig.setLoginLogo("cafa_logo");//logo图片
        yidongConfig.setLogoWidthDip(80);//图片宽度
        yidongConfig.setLogoHeightDip((int) (70*getDensityRatio()));//图片高度
        yidongConfig.setLogoOffsetY(100);//图片Y偏移量
        yidongConfig.setLogoHidden(false);//logo图片隐藏

        yidongConfig.setNumberColor(0xff333333);//手机号码字体颜色
        yidongConfig.setNumberSize(18);////手机号码字体大小
        yidongConfig.setNumFieldOffsetY(170);//号码栏Y偏移量

        yidongConfig.setSloganTextColor(0xff999999);//slogan文字颜色
        yidongConfig.setSloganTextSize(10);//slogan文字大小
        yidongConfig.setSloganOffsetY(230);//slogan声明标语Y偏移量

        yidongConfig.setLogBtnText("本机号码一键登录");//登录按钮文本
        yidongConfig.setLogBtnTextColor(0xffffffff);//登录按钮文本颜色
        yidongConfig.setLogBtnImgPath("");//登录按钮背景
        yidongConfig.setLogBtnSize(15);
        yidongConfig.setLogBtnOffsetY(254);//登录按钮Y偏移量

        yidongConfig.setSwitchAccTextColor(0xff329af3);//切换账号字体颜色
        yidongConfig.setShowOtherLogin(true);//切换账号是否隐藏
        yidongConfig.setSwitchAccTextSize(14);//切换账号字体大小
        yidongConfig.setSwitchOffsetY(310);//切换账号偏移量

        yidongConfig.setUncheckedImgPath("umcsdk_uncheck_image");//chebox未被勾选图片
        yidongConfig.setCheckedImgPath("umcsdk_check_image");//chebox被勾选图片
        yidongConfig.setCheckBoxImgPathSize(9);//勾选check大小
        yidongConfig.setPrivacyState(true);//授权页check
        yidongConfig.setPrivacyAlignment1("登录即同意");
        yidongConfig.setPrivacyAlignment2("应用自定义服务条款一");
        yidongConfig.setPrivacyAlignment3("https://www.baidu.com");
        yidongConfig.setPrivacyAlignment4("应用自定义服务条款二");
        yidongConfig.setPrivacyAlignment5("https://www.hao123.com");
        yidongConfig.setPrivacyAlignment6("并使用本机号码登录");
        yidongConfig.setPrivacyTextSize(10);
        yidongConfig.setPrivacyTextColor1(0xff666666);//文字颜色
        yidongConfig.setPrivacyTextColor2(0xff0085d0);//条款颜色
        yidongConfig.setPrivacyOffsetY_B(30);//隐私条款Y偏移量
        yidongConfig.setPrivacyMargin(50);
        uiConfig.setYiDongLoginConfig(yidongConfig);

        LoginUiConfig.LianTongLoginConfig lianTongLoginConfig = uiConfig.new LianTongLoginConfig();
        lianTongLoginConfig.setShowProtocolBox(false);//不展示协议的勾选框
        //注意，当setShowProtocolBox = false时，只能通过代码来设置按钮文字
        lianTongLoginConfig.setLoginButtonText("快捷登录");//按钮文字内容
        lianTongLoginConfig.setLoginButtonWidth(500);//按钮宽度
        lianTongLoginConfig.setLoginButtonHeight(100);//按钮高度
        lianTongLoginConfig.setOffsetY(100);//按钮Y轴距离
        lianTongLoginConfig.setProtocolCheckRes(cn.emay.ql.R.drawable.selector_button_cucc);//按钮点击背景
        lianTongLoginConfig.setProtocolUnCheckRes(cn.emay.ql.R.drawable.selector_button_ctc);//按钮未点击背景
        lianTongLoginConfig.setProtocolID("protocol_1");//xml布局中定义的控件id
        lianTongLoginConfig.setProtocolUrl("https://www.baidu.com");
        lianTongLoginConfig.setProtocolID1("protocol_2");//xml布局中定义的控件id
        uiConfig.setLianTongLoginConfig(lianTongLoginConfig);


        //隐私协议文本,其中配置说明如下
        // 1、$OAT 为运营商协议标题占位符，SDK程序默认替换为《天翼账号服务与隐私协议》，若有其它运营商协议配置需求，可添加配置；
        // 2、$CAT 为自定义协议标题占位符，SDK程序会替换为自定义标题字段的值；
        // 3、[应用名] ：修改为您应用的名称
        LoginUiConfig.DianXinLoginConfig dianXinLoginConfig = uiConfig.new DianXinLoginConfig();
        dianXinLoginConfig.setPrivacyText("登录即同意$OAT与$CAT并授权[本demo]获取本机号码");
        dianXinLoginConfig.setPrivacyTextColor(0xFF000000);//隐私协议文本的字体颜色
        dianXinLoginConfig.setPrivacyTextSize(12);//隐私协议文本的字体大小
        dianXinLoginConfig.setOperatorAgreementTitleColor(0xFF0090FF);//运营商协议标题的字体颜色
        dianXinLoginConfig.setCustomAgreementTitle("《我的自定义协议》");//自定义协议标题
        dianXinLoginConfig.setCustomAgreementLink("https://www.baidu.com");//自定义协议wap页面地址
        dianXinLoginConfig.setCustomAgreementTitleColor(0xFF0090FF);//自定义协议标题的字体颜色

        //弹窗登录设置弹窗大小，单位为px
        dianXinLoginConfig.setDialogHeight(1000);
        dianXinLoginConfig.setDialogWidth(DeviceUtil.getScreenWidth(activity));
        //弹窗弹出位置AuthPageConfig.BOTTOM,AuthPageConfig.CENTER
        dianXinLoginConfig.setLocation(AuthPageConfig.BOTTOM);

        uiConfig.setDianXinLoginConfig(dianXinLoginConfig);
        mLoginUiConfig = uiConfig;
        return true;
    }

    private LoginUiConfig getLoginUiConfig() {
        return mLoginUiConfig;
    }

    private void login(Result result) {
        Map<String,Object> resultMap = new HashMap<>();
        UniSDK.getInstance().login(activity, Constants.APP_ID, Constants.SECRET_KEY, new LoginCallback() {
            @Override
            public void onSuccess(String s) {
                Log.e(TAG, "===============================================");
                Log.e("onSuccess ==>", s);
                Log.e(TAG, "===============================================");
                activity.runOnUiThread(
                        new Runnable() {
                            @Override
                            public void run() {
                                resultMap.put(Constants.LOGIN_RESULT_KEY,"true");
                                resultMap.put(Constants.LOGIN_DATA_KEY,s);
                                String resultSuccess = JSON.toJSONString(resultMap);
                                result.success(resultSuccess);
                            }
                        });
            }

            @Override
            public void onFailed(String s) {
                Log.e(TAG, "===============================================");
                Log.e("onFailed ==>", s);
                Log.e(TAG, "===============================================");
                activity.runOnUiThread(
                        new Runnable() {
                            @Override
                            public void run() {
                                resultMap.put(Constants.LOGIN_RESULT_KEY,"false");
                                resultMap.put(Constants.LOGIN_DATA_KEY,s);
                                String resultFailed = JSON.toJSONString(resultMap);
                                result.success(resultFailed);
                            }
                        });
            }
        }, getLoginUiConfig(),false);
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == REQUEST_CODE_PERMISSION) {
            //用户同意权限申请
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
//        isPermissionGrand = true;
            } else {
                //用户拒绝权限
//        isPermissionGrand = false;
                requestPermission();
            }
        }
        return false;
    }
    //根据手机像素密度获取其与标准360dp的比例，用于设置移动logo的高度
    private float getDensityRatio(){
        DisplayMetrics dm = activity.getResources().getDisplayMetrics();
        int screenWidth = dm.widthPixels;
        int screenHeight = dm.heightPixels;
        int densityDpi = dm.densityDpi;
        float densityRatio = densityDpi / 360.0f;
        Log.e(TAG, "getDensityRatio==============================================="+densityRatio);
        return densityRatio;
    }
}
