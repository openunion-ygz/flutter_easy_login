#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_easy_login'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  #引入资源文件(可引入多个，以“，”隔开，如： s.source_files = 'Classes/**/*','UPPay/**/*')
  s.source_files = 'Classes/**/*'
  #引入头文件，包括三方引入的头文件，如： s.public_header_files = 'Classes/**/*.h','UPPay/**/*.h'
  s.public_header_files = 'Classes/**/*.h'
  #以中央仓库的方式引入frameworks，如引入微信SDK：  s.dependency 'WechatOpenSDK'
  s.dependency 'Flutter'

  #s.ios.vendored_libraries = 'UPPay/**/*.a' 表示引入静态库，主要为 .a 文件
  #s.ios.frameworks = 'CFNetwork','SystemConfiguration' 表示引入系统的frameworks
  #s.ios.libraries = 'stdc++','z' 引入系统库
  #s.preserve_paths = 'UPPay/*.a

  # 当使用依赖中央仓库的方式引入frameworks的方式找不到对应的头文件时，需要手动声明头文件，以不全头文件的路径
  #s.prefix_header_contents = '#import <WechatOpenSDK/WXApi.h>','#import <flutter_oupay/FlutterOupayPlugin.h>'

  s.ios.deployment_target = '8.0'
  #引入三方静态库
  # frameworks 其他资源文件'SDK/ThirdPartyLibs/chinaTelecom/*.bundle','SDK/ThirdPartyLibs/cmcc/*.bundle'
  s.ios.vendored_frameworks = 'SDK/UniLogin.UniLogin.framework','SDK/ThirdPartyLibs/chinaunicom.OAuth.framework','SDK/ThirdPartyLibs/cmcc/TYRZSDK.framework','SDK/ThirdPartyLibs/chinaTelecom/EAccountHYSDK.framework'
  s.static_framework = true
end

