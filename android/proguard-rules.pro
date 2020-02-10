# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

#亿美一键登录混淆

#ct天翼账号SDK
-keep class com.cmic.sso.sdk.**{*;}
-keep class cn.com.chinatelecom.account.**{*;}
# cmcc中国移动一键免密登录
-dontwarn com.cmic.sso.sdk.**
-keep class com.cmic.sso.sdk.**{*;}
#cu 小沃科技免密登录sdk
-dontwarn com.unicom.xiaowo.login.**
-keep class com.unicom.xiaowo.login.**{*;}
-dontwarn com.sdk.**
-keep class com.sdk.** { *;}
#cmcc
-dontwarn com.cmcc.allnetlogin.**
-keep class com.cmcc.allnetlogin.client.**{*;}
-keep class com.cmcc.allnetlogin.model.**{*;}
-keep class com.cmcc.allnetlogin.http.**{*;}
-keep class com.cmcc.allnetlogin.utils.**{*;}
-keep class org.apache.commons.codec1.**{*;}
#emay
-keep class cn.emay.ql.UniSDK{*;}
-keep class cn.emay.ql.LoginCallback{*;}
-keep class cn.emay.ql.UniLoginActivity{*;}
-keep class cn.emay.ql.utils.**{*;}

