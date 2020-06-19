
part of 'login_theme_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginThemeConfig _$LoginThemeConfigFromJson(Map<String, dynamic> json) {
  return LoginThemeConfig(
      useDefaultTheme: json['useDefaultTheme'] as bool,
      navColor: json['navColor'] as int,
      navText: json['navText'] as String,
      navTextColor: json['navTextColor'] as int,
      navReturnImgPath: json['navReturnImgPath'] as String,
      authNavTransparent: json['authNavTransparent'] as bool,
      logoImgPath: json['logoImgPath'] as String,
      logoWidth: json['logoWidth'] as int,
      logoHeight: json['logoHeight'] as int,
      logBtnText: json['logBtnText'] as String,
      logBtnTextColor: json['logBtnTextColor'] as int,
      logBtnImgPath: json['logBtnImgPath'] as String,
      clauseOneName: json['clauseOneName'] as String,
      clauseOneUrl: json['clauseOneUrl'] as String,
      clauseTwoName: json['clauseTwoName'] as String,
      clauseTwoUrl: json['clauseTwoUrl'] as String,
      clauseColorBase: json['clauseColorBase'] as int,
      clauseColorAgree: json['clauseColorAgree'] as int,
      otherWayLogin: json['otherWayLogin'] as bool);

}

Map<String, dynamic> _$LoginThemeConfigToJson(
    LoginThemeConfig instance) =>
    <String, dynamic>{
      'useDefaultTheme':instance.useDefaultTheme,
      'navColor': instance.navColor,
      'navText': instance.navText,
      'navTextColor': instance.navTextColor,
      'navReturnImgPath': instance.navReturnImgPath,
      'authNavTransparent': instance.authNavTransparent,
      'logoImgPath': instance.logoImgPath,
      'logoWidth': instance.logoWidth,
      'logoHeight': instance.logoHeight,
      'logBtnText': instance.logBtnText,
      'logBtnTextColor': instance.logBtnTextColor,
      'logBtnImgPath': instance.logBtnImgPath,
      'clauseOneName': instance.clauseOneName,
      'clauseOneUrl': instance.clauseOneUrl,
      'clauseTwoName': instance.clauseTwoName,
      'clauseTwoUrl': instance.clauseTwoUrl,
      'clauseColorBase': instance.clauseColorBase,
      'clauseColorAgree': instance.clauseColorAgree,
      'otherWayLogin':instance.otherWayLogin,
    };