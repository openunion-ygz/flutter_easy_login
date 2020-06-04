#import "FlutterEasyLoginPlugin.h"
//#import <flutter_easy_login/flutter_easy_login-Swift.h>

#import "UniLogin/UniLogin.h"
#import "NSData+AES.h"

#define AppId @"f5b044a76b2341daa27b656e5e69ce22"
#define SecretKey @"92eec5356dda4216"

#define SecretKey_Phone @"6f5987e2d6b14543"

__weak FlutterEasyLoginPlugin* __FlutterEasyLoginPlugin;
@property (readwrite,copy,nonatomic) FlutterResult __result;
//自定义协议文案
@property (readwrite,copy,nonatomic) NSString * appPrivacyOneText;
//自定义协议url
@property (readwrite,copy,nonatomic) NSString * appPrivacyOneUrl;

@property (readwrite,copy,nonatomic) NSString * appId;

@property (readwrite,copy,nonatomic) NSString * secretKey;

@implementation FlutterEasyLoginPlugin{
    UIViewController *_viewController;
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
        __FlutterEasyLoginPlugin  = self;
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  //[SwiftFlutterEasyLoginPlugin registerWithRegistrar:registrar];
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:@"flutter_easy_login"
              binaryMessenger:[registrar messenger]];
    UIViewController *viewController =
        [UIApplication sharedApplication].delegate.window.rootViewController;
    FlutterEasyLoginPlugin* instance = [[FlutterEasyLoginPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    self.__result = result;
 if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if([@"initSdk" isEqualToString:call.method]){
      self.appId = call.arguments[@"appId"];
       self.secretKey = call.arguments[@"secretKey"];
  result(YES)
  }else if([@"setLoginUiConfig" isEqualToString:call.method]){
      self.appPrivacyOneText = call.arguments[@"protocolText"];
      self.appPrivacyOneUrl = call.arguments[@"protocolUrl"];
      result(YES);
  }else if([@"login" isEqualToString:call.method]){
    UniLogin *loginSDK = [UniLogin shareInstance];

    UIImage *logo = [UIImage imageNamed: @"Images/cafa_logo.png"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cafa_logo.png" ofType:nil inDirectory:@"Images"];
    logo = [[UIImage alloc]initWithContentsOfFile:path];
      //UIImage *logo = [UIImage imageNamed:@"cafa_logo"];
      loginSDK.cmccLogoImg = logo;
      loginSDK.cuccLogoImg = logo;
      loginSDK.ctccLogoImg = logo;

      loginSDK.cmccSwithAccHidden = YES;
      loginSDK.cuccSwithAccHidden = YES;
      loginSDK.ctccSwithAccHidden = YES;

      NSArray *arr = nil;
      if(!self.appPrivacyOneText && !self.appPrivacyOneUrl){
      arr =  @[@self.appPrivacyOneText,@self.appPrivacyOneUrl];
      }else{
      arr = @[@"用户自定义协议",@"https://www.baidu.com"];
      }
      //NSArray *arr = @[@"用户自定义协议",@"https://www.baidu.com"];
      loginSDK.cmccAppPrivacyOne = arr;
      loginSDK.cuccAppPrivacyOne = arr;
      loginSDK.ctccAppPrivacyOne = arr;

      loginSDK.appPrivacyTwo = @[@"用户自定义协议_移动专属",@"https://www.baidu.com"];

      [[UniLogin shareInstance] loginWithViewControler:self appId:self.appId secretKey:self.secretKey complete:^(NSString * _Nullable mobile, NSString * _Nullable msg) {
          NSString *decMobile = nil;
          //登录结果以json形式返回
          NSDictionary *loginData = nil;
          if(){
             NSLog(@"初始化失败");
             loginData = @{@"login_result":@NO,@"login_data":@"初始化异常，请联系管理人员"};
            }else{
                if (mobile) {
                          NSLog(@"登录成功");
                         // decMobile = [self decryptWithStr:mobile];
                         loginData = @{@"login_result":@YES,@"login_data":@mobile};
                      }else {
                          NSLog(@"登录失败");
                          loginData = @{@"login_result":@NO,@"login_data":@msg};
                      }
                }

          //[self showResultData:decMobile msg:msg];
          result(loginData);
      }];

  }else {
       result(FlutterMethodNotImplemented);
     }

}
@end
