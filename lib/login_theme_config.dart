import 'package:json_annotation/json_annotation.dart';

part 'login_theme_config.g.dart';

@JsonSerializable(nullable: false)
class LoginThemeConfig{
  bool useDefaultTheme;///是否使用默认的页面样式
  ///授权页导航栏
  int navColor; ///设置导航栏颜色
  String navText; ///设置导航栏标题文字
  int navTextColor; ///设置导航栏标题文字颜色
  String navReturnImgPath;  ///设置导航栏返回按钮图标
  bool authNavTransparent; ///设置授权页导航栏透明
  ///
  ///授权页logo
  String logoImgPath; ///设置logo图片
  int logoWidth;  ///设置logo宽度
  int logoHeight; ///设置logo高度

  ///授权页登录按钮
  String logBtnText; ///设置登录按钮文字
  int logBtnTextColor; ///设置登录按钮文字颜色
  String logBtnImgPath; ///设置授权登录按钮图片

  ///授权页隐私栏
  String clauseOneName; ///设置开发者隐私条款1名称和URL(名称，url)
  String clauseOneUrl;
  String clauseTwoName; ///设置开发者隐私条款2名称和URL(名称，url)
  String clauseTwoUrl;
  int clauseColorBase;  ///设置隐私条款名称颜色(基础文字颜色，协议文字颜色)
  int clauseColorAgree;
  ///是否显示其他登录方式
  bool otherWayLogin;

  LoginThemeConfig({
    bool useDefaultTheme:true,
    int navColor,
    String navText : "统一认证登录",
    int navTextColor : -1,
    String navReturnImgPath,
    bool authNavTransparent : false,
    String logoImgPath,
    int logoWidth ,
    int logoHeight,
    String logBtnText : "本机号码一键登录",
    int logBtnTextColor : -1,
    String logBtnImgPath ,
    String clauseOneName,
    String clauseOneUrl,
    String clauseTwoName,
    String clauseTwoUrl,
    int clauseColorBase,
    int clauseColorAgree,
    bool otherWayLogin:true,
  }){
    this.useDefaultTheme =      useDefaultTheme;
    this.navColor=              navColor;
    this.navText=               navText;
    this.navTextColor=          navTextColor;
    this.navReturnImgPath=      navReturnImgPath;
    this.authNavTransparent =   authNavTransparent;
    this.logoImgPath=           logoImgPath;
    this.logoWidth=             logoWidth;
    this.logoHeight=            logoHeight;
    this.logBtnText=            logBtnText;
    this.logBtnTextColor=       logBtnTextColor;
    this.logBtnImgPath=         logBtnImgPath;
    this.clauseOneName=         clauseOneName;
    this.clauseOneUrl=          clauseOneUrl;
    this.clauseTwoName=         clauseTwoName;
    this.clauseTwoUrl=          clauseTwoUrl;
    this.clauseColorBase=       clauseColorBase;
    this.clauseColorAgree=      clauseColorAgree;
    this.otherWayLogin=         otherWayLogin;
  }

  factory LoginThemeConfig.fromJson(Map<String, dynamic> json) => _$LoginThemeConfigFromJson(json);

  Map<String, dynamic> toJson() => _$LoginThemeConfigToJson(this);
}