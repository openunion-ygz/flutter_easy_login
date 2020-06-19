package com.opun.flutter_easy_login;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.util.DisplayMetrics;
import android.util.Log;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.alibaba.fastjson.JSON;

import org.json.JSONException;
import org.json.JSONObject;

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
    private String appId;
    private String secretKey;

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
                appId = call.argument(Constants.APPID_KEY);
                secretKey = call.argument(Constants.SECRET_KEY);
                String version = UniSDK.getInstance().getVersion();
                requestPermission();
                result.success(null);
                break;
            }
            ///v3.1版本
            case "setLoginUiConfig": {
                String protocolText = call.argument(Constants.PARAM_KEY_PROTOCOL_TEXT);
                String protocolUrl = call.argument(Constants.PARAM_KEY_PROTOCOL_URL);
                Log.e("protocolText===>", protocolText);
                Log.e("protocolUrl===>", protocolUrl);
                result.success(setLoginUiConfig(protocolText, protocolUrl));
                break;
            }
            ///v4.0版本
            case "setLoginThemeConfig": {
                result.success(setLoginThemeConfig(call));
                break;
            }

            case "login": {
                int phoneStatePermission = ContextCompat.checkSelfPermission(activity.getApplicationContext(), Manifest.permission.READ_PHONE_STATE);
                if (phoneStatePermission == PackageManager.PERMISSION_GRANTED) {
                    if (getLoginUiConfig() != null) {
                        login(result);
                    } else {
                        setLoginThemeConfig(call);
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
        yidongConfig.setLogoHeightDip((int) (70 / 2 * getDensityRatio()));//图片高度
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

    private boolean setLoginThemeConfig(MethodCall call) {
        //默认使用sdk主题
        boolean isUseDefaultTheme = true;
        if (call.argument("useDefaultTheme") != null) {
            isUseDefaultTheme = call.argument("useDefaultTheme");
        }

        LoginUiConfig uiConfig = new LoginUiConfig();
        LoginUiConfig.YiDongLoginConfig yidongConfig = uiConfig.new YiDongLoginConfig();
        LoginUiConfig.LianTongLoginConfig lianTongLoginConfig = uiConfig.new LianTongLoginConfig();
        LoginUiConfig.DianXinLoginConfig dianXinLoginConfig = uiConfig.new DianXinLoginConfig();

        yidongConfig.setStatusBarColor(0xff0086d0);
        yidongConfig.setAuthBGImgPath("");//设置背景图
        yidongConfig.setNavReturnSize(30);//返回图标大小
        yidongConfig.setNavTextSize(17);
        yidongConfig.setLogoOffsetY(100);//图片Y偏移量
        yidongConfig.setLogoHidden(false);//logo图片隐藏

        yidongConfig.setNumberColor(0xff333333);//手机号码字体颜色
        yidongConfig.setNumberSize(18);////手机号码字体大小
        yidongConfig.setNumFieldOffsetY(170);//号码栏Y偏移量

        yidongConfig.setSloganTextColor(0xff999999);//slogan文字颜色
        yidongConfig.setSloganTextSize(10);//slogan文字大小
        yidongConfig.setSloganOffsetY(230);//slogan声明标语Y偏移量
        yidongConfig.setLogBtnSize(15);
        yidongConfig.setLogBtnOffsetY(254);//登录按钮Y偏移量

        yidongConfig.setSwitchAccTextColor(0xff329af3);//切换账号字体颜色
        yidongConfig.setShowOtherLogin(false);//切换账号是否隐藏
        yidongConfig.setSwitchAccTextSize(14);//切换账号字体大小
        yidongConfig.setSwitchOffsetY(310);//切换账号偏移量

        yidongConfig.setUncheckedImgPath("umcsdk_uncheck_image");//chebox未被勾选图片
        yidongConfig.setCheckedImgPath("umcsdk_check_image");//chebox被勾选图片
        yidongConfig.setCheckBoxImgPathSize(9);//勾选check大小
        yidongConfig.setPrivacyState(true);//授权页check
        yidongConfig.setPrivacyAlignment1("登录即同意");
        yidongConfig.setPrivacyAlignment6("并使用本机号码登录");
        yidongConfig.setPrivacyTextSize(10);
        yidongConfig.setPrivacyOffsetY_B(30);//隐私条款Y偏移量
        yidongConfig.setPrivacyMargin(50);

        lianTongLoginConfig.setShowProtocolBox(false);//不展示协议的勾选框
        lianTongLoginConfig.setLoginButtonWidth(500);//按钮宽度
        lianTongLoginConfig.setLoginButtonHeight(100);//按钮高度
        lianTongLoginConfig.setOffsetY(100);//按钮Y轴距离
        lianTongLoginConfig.setProtocolCheckRes(cn.emay.ql.R.drawable.selector_button_cucc);//按钮点击背景
        lianTongLoginConfig.setProtocolUnCheckRes(cn.emay.ql.R.drawable.selector_button_ctc);//按钮未点击背景
        lianTongLoginConfig.setProtocolID("protocol_1");//xml布局中定义的控件id
        lianTongLoginConfig.setProtocolID1("protocol_2");//xml布局中定义的控件id

        //隐私协议文本,其中配置说明如下
        // 1、$OAT 为运营商协议标题占位符，SDK程序默认替换为《天翼账号服务与隐私协议》，若有其它运营商协议配置需求，可添加配置；
        // 2、$CAT 为自定义协议标题占位符，SDK程序会替换为自定义标题字段的值；
        // 3、[应用名] ：修改为您应用的名称
        dianXinLoginConfig.setPrivacyText("登录即同意$OAT与$CAT并授权" + getAppName() + "获取本机号码");
        dianXinLoginConfig.setPrivacyTextSize(12);//隐私协议文本的字体大小
        dianXinLoginConfig.setOperatorAgreementTitleColor(0xFF0090FF);//运营商协议标题的字体颜色
        //弹窗登录设置弹窗大小，单位为px
        dianXinLoginConfig.setDialogHeight(1000);
        dianXinLoginConfig.setDialogWidth(DeviceUtil.getScreenWidth(activity));
        //弹窗弹出位置AuthPageConfig.BOTTOM,AuthPageConfig.CENTER
        dianXinLoginConfig.setLocation(AuthPageConfig.BOTTOM);
        if (isUseDefaultTheme) {
            yidongConfig.setAuthNavTransparent(false);//授权页head是否隐藏
            yidongConfig.setNavColor(0xff0086d0);//导航栏颜色
            yidongConfig.setNavReturnImgPath("");//导航返回图标
            yidongConfig.setNavText("登录");//导航栏标题
            yidongConfig.setNavTextColor(0xffffffff);//导航栏字体颜色
            yidongConfig.setLoginLogo("cafa_logo");//logo图片
            yidongConfig.setLogoWidthDip(80);//图片宽度
            yidongConfig.setLogoHeightDip((int) (70 / 2 * getDensityRatio()));//图片高度
            yidongConfig.setLogBtnText("本机号码一键登录");//登录按钮文本
            yidongConfig.setLogBtnTextColor(0xffffffff);//登录按钮文本颜色
            yidongConfig.setLogBtnImgPath("");//登录按钮背景
            yidongConfig.setPrivacyAlignment2("应用自定义服务条款一");
            yidongConfig.setPrivacyAlignment3("https://www.baidu.com");
            yidongConfig.setPrivacyAlignment4("应用自定义服务条款二");
            yidongConfig.setPrivacyAlignment5("https://www.hao123.com");
            yidongConfig.setPrivacyTextColor1(0xff666666);//文字颜色
            yidongConfig.setPrivacyTextColor2(0xff0085d0);//条款颜色
            yidongConfig.setShowOtherLogin(false);//默认显示“其他登录方式”

            //注意，当setShowProtocolBox = false时，只能通过代码来设置按钮文字
            lianTongLoginConfig.setLoginButtonText("快捷登录");//按钮文字内容
            lianTongLoginConfig.setProtocolUrl("https://www.baidu.com");
            lianTongLoginConfig.setShowOtherLogin(true);

            dianXinLoginConfig.setPrivacyTextColor(0xFF000000);//隐私协议文本的字体颜色
            dianXinLoginConfig.setCustomAgreementTitle("《我的自定义协议》");//自定义协议标题
            dianXinLoginConfig.setCustomAgreementLink("https://www.baidu.com");//自定义协议wap页面地址
            dianXinLoginConfig.setCustomAgreementTitleColor(0xFF0090FF);//自定义协议标题的字体颜色
        } else {
            Number navColor = 0xff0086d0;
            if (call.argument("navColor") != null) {
                navColor = call.argument("navColor");
            }
            yidongConfig.setNavColor(navColor.intValue());//导航栏颜色

            String navText = "登录";
            if (call.argument("navText") != null) {
                navText = call.argument("navText");
            }
            yidongConfig.setNavText(navText);//导航栏标题

            Number navTextColor = 0xffffffff;
            if (call.argument("navTextColor") != null) {
                navTextColor = call.argument("navTextColor");
            }
            yidongConfig.setNavTextColor(navTextColor.intValue());//导航栏字体颜色

            String navReturnImgPath = "";
            if (call.argument("navReturnImgPath") != null) {
                navReturnImgPath = call.argument("navReturnImgPath");
            }
            yidongConfig.setNavReturnImgPath(navReturnImgPath);//导航返回图标

            boolean authNavTransparent = false;
            if (call.argument("authNavTransparent") != null) {
                authNavTransparent = call.argument("authNavTransparent");
            }
            yidongConfig.setAuthNavTransparent(authNavTransparent);//授权页head是否隐藏

            String logoImgPath = "cafa_logo";
            if (call.argument("logoImgPath") != null) {
                logoImgPath = call.argument("logoImgPath");
            }
            yidongConfig.setLoginLogo(logoImgPath);//logo图片

            int logoWidth = 80;
            if (call.argument("logoWidth") != null) {
                logoWidth = call.argument("logoWidth");
            }
            yidongConfig.setLogoWidthDip(logoWidth);//图片宽度
            int logoHeight = 70;
            if (call.argument("logoHeight") != null) {
                logoHeight = call.argument("logoHeight");
            }
            yidongConfig.setLogoHeightDip((int) (logoHeight / 2 * getDensityRatio()));//图片高度

            String logBtnText;
            if (call.argument("logBtnText") != null) {
                logBtnText = call.argument("logBtnText");
                yidongConfig.setLogBtnText(logBtnText);//登录按钮文本
                lianTongLoginConfig.setLoginButtonText(logBtnText);//按钮文字内容
            } else {
                yidongConfig.setLogBtnText("本机号码一键登录");//登录按钮文本
                lianTongLoginConfig.setLoginButtonText("快捷登录");//按钮文字内容
            }


            Number logBtnTextColor = 0xffffffff;
            if (call.argument("logBtnTextColor") != null) {
                logBtnTextColor = call.argument("logBtnTextColor");
            }
            yidongConfig.setLogBtnTextColor(logBtnTextColor.intValue());//登录按钮文本颜色

            String logBtnImgPath = "";
            if (call.argument("logBtnImgPath") != null) {
                logBtnImgPath = call.argument("logBtnImgPath");
            }
            yidongConfig.setLogBtnImgPath(logBtnImgPath);//登录按钮背景

            String clauseOneName = "应用自定义服务条款一";
            if (call.argument("clauseOneName") != null) {
                clauseOneName = call.argument("clauseOneName");
            }
            yidongConfig.setPrivacyAlignment2(clauseOneName);
            dianXinLoginConfig.setCustomAgreementTitle(clauseOneName);//自定义协议标题

            String clauseOneUrl = "https://www.baidu.com";
            if (call.argument("clauseOneUrl") != null) {
                clauseOneUrl = call.argument("clauseOneUrl");
            }
            yidongConfig.setPrivacyAlignment3(clauseOneUrl);
            lianTongLoginConfig.setProtocolUrl(clauseOneUrl);
            dianXinLoginConfig.setCustomAgreementLink(clauseOneUrl);//自定义协议wap页面地址

            String clauseTwoName = "应用自定义服务条款二";
            if (call.argument("clauseTwoName") != null) {
                clauseTwoName = call.argument("clauseTwoName");
            }
            yidongConfig.setPrivacyAlignment4(clauseTwoName);

            String clauseTwoUrl = "https://www.hao123.com";
            if (call.argument("clauseTwoUrl") != null) {
                clauseTwoUrl = call.argument("clauseTwoUrl");
            }
            yidongConfig.setPrivacyAlignment5(clauseTwoUrl);

            Number clauseColorBase = -1;
            if (call.argument("clauseColorBase") != null) {
                clauseColorBase = call.argument("clauseColorBase");
                yidongConfig.setPrivacyTextColor1(clauseColorBase.intValue());//文字颜色
                dianXinLoginConfig.setPrivacyTextColor(clauseColorBase.intValue());//隐私协议文本的字体颜色
            } else {
                yidongConfig.setPrivacyTextColor1(0xff666666);//文字颜色
                dianXinLoginConfig.setPrivacyTextColor(0xFF000000);//隐私协议文本的字体颜色
            }

            Number clauseColorAgree = -1;
            if (call.argument("clauseColorAgree") != null) {
                clauseColorAgree = call.argument("clauseColorAgree");
                yidongConfig.setPrivacyTextColor2(clauseColorAgree.intValue());//条款颜色
                dianXinLoginConfig.setCustomAgreementTitleColor(clauseColorAgree.intValue());//自定义协议标题的字体颜色
            } else {
                yidongConfig.setPrivacyTextColor2(0xff0085d0);//条款颜色
                dianXinLoginConfig.setCustomAgreementTitleColor(0xFF0090FF);//自定义协议标题的字体颜色
            }
            boolean showOtherWayLogin = true;
            if (call.argument("otherWayLogin") != null) {
                showOtherWayLogin = call.argument("otherWayLogin");
            }
            yidongConfig.setShowOtherLogin(showOtherWayLogin);
            lianTongLoginConfig.setShowOtherLogin(showOtherWayLogin);
        }
        uiConfig.setYiDongLoginConfig(yidongConfig);
        uiConfig.setLianTongLoginConfig(lianTongLoginConfig);
        uiConfig.setDianXinLoginConfig(dianXinLoginConfig);
        mLoginUiConfig = uiConfig;
        return true;
    }

    private String getAppName() {
        String appName = "当前应用";
        if (activity.getApplicationContext() != null) {
            try {
                PackageManager packageManager = activity.getApplicationContext().getPackageManager();
                appName = String.valueOf(packageManager.getApplicationLabel(activity.getApplicationContext().getApplicationInfo()));
            } catch (Throwable e) {
                Log.i(TAG, "getAppName >> e:" + e.toString());
            }
        }
        return appName;
    }

    private LoginUiConfig getLoginUiConfig() {
        return mLoginUiConfig;
    }

    private String errorData = "";

    private void login(Result result) {
        Map<String, Object> resultMap = new HashMap<>();
        if (appId.isEmpty() || secretKey.isEmpty()) {
            resultMap.put(Constants.LOGIN_RESULT_KEY, "false");
            resultMap.put(Constants.LOGIN_DATA_KEY, "初始化异常，请联系管理人员");
            String resultFailed = JSON.toJSONString(resultMap);
            result.success(resultFailed);
        } else {
            UniSDK.getInstance().login(activity, appId, secretKey, new LoginCallback() {
                @Override
                public void onSuccess(String s) {
                    Log.e(TAG, "===============================================");
                    Log.e("onSuccess ==>", s);
                    Log.e(TAG, "===============================================");
                    activity.runOnUiThread(
                            new Runnable() {
                                @Override
                                public void run() {
                                    resultMap.put(Constants.LOGIN_RESULT_KEY, "true");
                                    resultMap.put(Constants.LOGIN_DATA_KEY, s);
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
                    errorData = s;
                    if (NetUtils.getOperatorType(activity.getApplicationContext()).equals(Constants.NET_TYPE_CMCC)) {
                        //移动
                        Log.e("OperatorType ==>", "移动");
                        if (errorData.equals("用户取消登录")) {
                            errorData = Constants.USER_CANCEL_STATE;
                        }
                        if (errorData.equals("")) {
                            errorData = Constants.OTHER_WAY_LOGIN;
                        }

                    } else if (NetUtils.getOperatorType(activity.getApplicationContext()).equals(Constants.NET_TYPE_CUCC)) {
                        //联通
                        Log.e("OperatorType ==>", "联通");
                        if (errorData.equals("用户取消登录")) {
                            errorData = Constants.USER_CANCEL_STATE;
                        }
                        if (errorData.equals("")) {
                            errorData = Constants.OTHER_WAY_LOGIN;
                        }

                    } else if (NetUtils.getOperatorType(activity.getApplicationContext()).equals(Constants.NET_TYPE_CUCC)) {
                        //电信
                        Log.e("OperatorType ==>", "电信");
                        if (errorData != null) {
                            JSONObject jsonObject = null;
                            int resultCode = 0;
                            try {
                                jsonObject = new JSONObject(s);
                                resultCode = jsonObject.getInt("result");
                                //用户取消登录
                                if (resultCode == 80200) {
                                    errorData = Constants.USER_CANCEL_STATE;
                                }
                                //其他登录方式
                                if (resultCode == 80201) {
                                    errorData = Constants.OTHER_WAY_LOGIN;
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }

                        }


                    }
                    activity.runOnUiThread(
                            new Runnable() {
                                @Override
                                public void run() {
                                    resultMap.put(Constants.LOGIN_RESULT_KEY, "false");
                                    resultMap.put(Constants.LOGIN_DATA_KEY, errorData);
                                    String resultFailed = JSON.toJSONString(resultMap);
                                    result.success(resultFailed);
                                }
                            });
                }
            }, getLoginUiConfig(), false);
        }
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
    private float getDensityRatio() {
        DisplayMetrics dm = activity.getResources().getDisplayMetrics();
        int screenWidth = dm.widthPixels;
        int screenHeight = dm.heightPixels;
        int densityDpi = dm.densityDpi;
        float densityRatio = densityDpi / 360.0f;
        Log.e(TAG, "getDensityRatio===============================================" + densityRatio);
        return densityRatio;
    }
}
