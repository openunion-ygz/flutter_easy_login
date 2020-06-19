#import "FlutterEasyLoginPlugin.h"
//#import <flutter_easy_login/flutter_easy_login-Swift.h>

#import "UniLogin/UniLogin.h"
#import "NSData+AES.h"


__weak FlutterEasyLoginPlugin* __FlutterEasyLoginPlugin;
@property (readwrite,copy,nonatomic) FlutterResult __result;
//自定义协议文案
@property (readwrite,copy,nonatomic) NSString *appPrivacyOneText;
//自定义协议url
@property (readwrite,copy,nonatomic) NSString *appPrivacyOneUrl;

@property (readwrite,copy,nonatomic) NSString *appId;

@property (readwrite,copy,nonatomic) NSString *secretKey;
//NSDictionary
@property (readwrite,copy,nonatomic) NSDictionary *themeConfigDict
// ZOAUCustomModel *mAuthPage 联通model
@property (readwrite,copy,nonatomic) ZOAUCustomModel *mAuthPage;
// UACustomModel *model 移动model
@property (readwrite,copy,nonatomic) UACustomModel *model;
// EAccountOpenPageConfig *config 电信model
@property (readwrite,copy,nonatomic) EAccountOpenPageConfig *config;
//  YMCustomConfig *config
@property (readwrite,copy,nonatomic) YMCustomConfig *ymConfig;

UIColor *hexColor(long hex) {
    long red = (hex & 0xff0000) >> 16;
    long green = (hex & 0x00ff00) >> 8;
    long blue = (hex & 0x0000ff) >> 0;
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

NSInteger *colorToHex(UIColor color){
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return (int)(r*255)<<16 | (int)(g*255)<<8 | (int)(b*255);
}

BOOL isExistKeyValue(NSDictionary* dict, NSString* key ) {
    if(![dict objectForKey:key]){
        return NO;
    }
    id obj = [dict objectForKey:key];
    return ![obj isEqual:[NSNull null]];
}

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
  }else if(@"setLoginThemeConfig" isEqualToString:call.method]){
      self.ymConfig = [YMCustomConfig new];
      self.themeConfigDic = call.arguments;
      //移动
      self.model = [self createCMCCModel];
      //联通
      self.mAuthPage = [self createCUCCModel];
      //电信
      self.config = [self createCTCCModel];
  }else if([@"login" isEqualToString:call.method]){
    UniLogin *loginSDK = [UniLogin shareInstance];

    //UIImage *logo = [UIImage imageNamed: @"Images/cafa_logo.png"];
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"cafa_logo.png" ofType:nil inDirectory:@"Images"];
    //logo = [[UIImage alloc]initWithContentsOfFile:path];
      //UIImage *logo = [UIImage imageNamed:@"cafa_logo"];
      //loginSDK.cmccLogoImg = logo;
      //loginSDK.cuccLogoImg = logo;
      //loginSDK.ctccLogoImg = logo;

      //loginSDK.cmccSwithAccHidden = YES;
      //loginSDK.cuccSwithAccHidden = YES;
      //loginSDK.ctccSwithAccHidden = YES;

      //NSArray *arr = nil;
      //if(!self.appPrivacyOneText && !self.appPrivacyOneUrl){
      //arr =  @[@self.appPrivacyOneText,@self.appPrivacyOneUrl];
      //}else{
      //arr = @[@"用户自定义协议",@"https://www.baidu.com"];
      //}
      //NSArray *arr = @[@"用户自定义协议",@"https://www.baidu.com"];
      //loginSDK.cmccAppPrivacyOne = arr;
      //loginSDK.cuccAppPrivacyOne = arr;
      //loginSDK.ctccAppPrivacyOne = arr;

      //loginSDK.appPrivacyTwo = @[@"用户自定义协议_移动专属",@"https://www.baidu.com"];
      if(!self.ymConfig){
         self.ymConfig = [YMCustomConfig new];
      }
       if(!self.model){
        self.model = [self createCMCCModel];
          }
       if(!self.mAuthPage){
        self.mAuthPage = [self createCUCCModel];
          }
       if(!self.config){
        self.config = [self createCTCCModel];
          }
          self.ymConfig.cmccModel = self.model;
          self.ymConfig.cuccModel = self.mAuthPage;
          self.ymConfig.ctccModel = self.config;

      [[UniLogin shareInstance] loginWithViewControler:self customConfig:self.ymConfig appId:self.appId secretKey:self.secretKey complete:^(NSString * _Nullable mobile, NSString * _Nullable msg) {
          NSString *decMobile = nil;
          //登录结果以json形式返回
          NSDictionary *loginData = nil;
          if(mobile){
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
//移动model设置
(UACustomModel *)createCMCCModel:(NSDictionary)themeConfigDict{
UACustomModel *model = [UACustomModel new];
model.currentVC = self;
//默认使用亿美默认主题

//是否使用默认主题
BOOL useDefaultTheme = isExistKeyValue(themeConfigDict,@"useDefaultTheme") ? [[themeConfigDict objectForKey:@"useDefaultTheme"] boolValue]: YES;

//导航栏背景色
long navColor = isExistKeyValue(themeConfigDict,@"navColor")  ? [[themeConfigDict objectForKey:@"navColor"] longValue]: colorToHex([UIColor redColor]);
//导航栏标题
NSString navText = isExistKeyValue(themeConfigDict,@"navText") ? [themeConfigDict objectForKey:@"navText"] : @"统一认证登录";
//导航栏标题颜色
long navTextColor = isExistKeyValue(themeConfigDict,@"navTextColor")  ? [[themeConfigDict objectForKey:@"navTextColor"] longValue]: colorToHex([UIColor blackColor]) ;
//导航栏返回按钮图片路径
NSSString navReturnImgPath = isExistKeyValue(themeConfigDict,@"navReturnImgPath") ? [themeConfigDict objectForKey:@"navReturnImgPath"] : @"";
//是否隐藏导航栏（默认显示）
BOOL authNavTransparent = isExistKeyValue(themeConfigDict,@"useDefaultTheme") ? [[themeConfigDict objectForKey:@"useDefaultTheme"] boolValue]: NO;

//logo图片路径
NSString logoImgPath = isExistKeyValue(themeConfigDict,@"logoImgPath") ? [themeConfigDict objectForKey:@"logoImgPath"] : @"";
//logo图片宽度
int logoWidth =  isExistKeyValue(themeConfigDict,@"logoWidth")  ? [[themeConfigDict objectForKey:@"logoWidth"] intValue]: 300);
//logo图片高度
int logoHeight =  isExistKeyValue(themeConfigDict,@"logoHeight")  ? [[themeConfigDict objectForKey:@"logoHeight"] intValue]: 300);

//登录按钮文案
NSString logBtnText = isExistKeyValue(themeConfigDict,@"logBtnText") ? [themeConfigDict objectForKey:@"logBtnText"] : @"本机号码一键登录";
//登录按钮文案颜色
long logBtnTextColor = isExistKeyValue(themeConfigDict,@"logBtnTextColor")  ? [[themeConfigDict objectForKey:@"logBtnTextColor"] longValue]: colorToHex([UIColor orangeColor]);
//登录按钮背景图片路径
NSString logBtnImgPath = isExistKeyValue(themeConfigDict,@"logBtnImgPath") ? [themeConfigDict objectForKey:@"logBtnImgPath"] : @"";

//用户自定义协议1标题
NSString clauseOneName = isExistKeyValue(themeConfigDict,@"clauseOneName") ? [themeConfigDict objectForKey:@"clauseOneName"] : @"开联用户协议1";
//用户自定义协议1对应的url
NSString clauseOneUrl = isExistKeyValue(themeConfigDict,@"clauseOneUrl") ? [themeConfigDict objectForKey:@"clauseOneUrl"] : @"https://www.baidu.com";
//用户自定义协议2标题
NSString clauseTwoName = isExistKeyValue(themeConfigDict,@"clauseTwoName") ? [themeConfigDict objectForKey:@"clauseTwoName"] : @"开联用户协议2";
//用户自定义协议2对应的url
NSString clauseTwoUrl = isExistKeyValue(themeConfigDict,@"clauseTwoUrl") ? [themeConfigDict objectForKey:@"clauseTwoUrl"] : @"https://www.baidu.com";
//协议字体颜色
long clauseColorBase = isExistKeyValue(themeConfigDict,@"clauseColorBase")  ? [[themeConfigDict objectForKey:@"clauseColorBase"] longValue]: colorToHex([UIColor blackColor]);
//自定义协议字体颜色
long clauseColorAgree = isExistKeyValue(themeConfigDict,@"clauseColorAgree")  ? [[themeConfigDict objectForKey:@"clauseColorAgree"] longValue]: colorToHex([UIColor blackColor]);
//是否显示其他登录方式
BOOL showOtherWayLogin = isExistKeyValue(themeConfigDict,@"otherWayLogin") ? [[themeConfigDict objectForKey:@"otherWayLogin"] boolValue]: NO;


 // 是否开启自定义属性设置 appPrivacyAlignment 0 --使用默认 1--自定义
 model.appPrivacyAlignment = 0;
if(!useDefaultTheme){
 model.appPrivacyAlignment = 1;
}
 model.faceOrientation = UIInterfaceOrientationPortrait;
         //2、授权界面自定义控件View的Block
        // model.authViewBlock = ^(UIView *customView, CGRect logoFrame, CGRect numberFrame, CGRect sloganFrame, CGRect loginBtnFrame, CGRect checkBoxFrame, CGRect privacyFrame) {
          //  UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 400, 80)];
          //   [btn setTitle:@"我是自定义按钮" forState:(UIControlStateNormal)];
          //   [btn setTintColor:[UIColor blackColor]];
          //   [customView addSubview:btn];
        // };
         //3、授权页面推出的动画效果
         model.presentType = 3;
         //4、设置授权界面背景图片
     //    model.authPageBackgroundImage = [UIImage imageNamed:@"timg"];

         //*****************导航栏**********************
         //5、导航栏颜色
         model.navColor = hexColor(navColor);
         //6、状态栏着色样式0为黑色,1为白色
         model.barStyle = 1;
         //7、状态栏着色样式(隐藏导航栏时有效)*/
         model.statusBarStyle = 1;
         //8、导航栏标题颜色和字体修改  属性:你好  黄色
         model.navText = [[NSAttributedString alloc]initWithString:@navText attributes:@{NSForegroundColorAttributeName:hexColor(navTextColor)}];
         //9、导航栏
         model.navReturnImg = [UIImage imageNamed:@navReturnImgPath];
         //10、自定义导航栏开关(隐藏导航栏)--测试时留到最后设置
         model.navCustom = authNavTransparent;
         //11、右键按钮--
         model.navControl = [[UIBarButtonItem alloc]initWithTitle:@"授权右键" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightButtonItemAction)];

         //***************** LOGO图片设置******************
         //12、logo图片
         model.logoImg = [UIImage imageNamed:@logoImgPath];
         //13、Logo宽度设置
         model.logoWidth = logoWidth;
         //14、Logo的高度设置
         model.logoHeight = logoHeight;
         //15、Logo偏移量Y
         model.logoOffsetY = @50;
         //16、Logo隐藏开关
         model.logoHidden = YES;
         //17、登录按钮修改

         //***************** 登录按钮*******************
         model.logBtnText = [[NSAttributedString alloc]initWithString:@logBtnText attributes:@{NSForegroundColorAttributeName:hexColor(logBtnTextColor)}];
         //18、按钮偏移量Y
         model.logBtnOffsetY = @150;
         //19、按钮距离屏幕左右边距
         model.logBtnOriginX = @150;
         //20、登录按钮的高h
         model.logBtnHeight = 50;
         //21、授权界面登录按钮
         UIImage *norMal = [UIImage imageNamed:@"timg"];
         UIImage *invalied = [UIImage imageNamed:@"WechatIMG16"];
         UIImage *highted = [UIImage imageNamed:@"checkOn"];
         model.logBtnImgs = @[norMal,invalied,highted];

         //******************** 号码框设置*****************
         //22、号码栏字体大小
         model.numberText = [[NSAttributedString alloc]initWithString:@"sfdsfd" attributes:@{NSForegroundColorAttributeName:UIColor.orangeColor,NSFontAttributeName:[UIFont systemFontOfSize:30]}];
         //23、号码栏X偏移量
         model.numberOffsetX = @50;
         //24、号码栏Y偏移量
         model.numberOffsetY = @100;
         //25、切换按钮隐藏开关
         model.swithAccHidden = !showOtherWayLogin;
         //26、切换账号
         model.switchAccText = [[NSAttributedString alloc]initWithString:@"自定义切换账号" attributes:@{NSForegroundColorAttributeName:UIColor.redColor,NSFontAttributeName:[UIFont systemFontOfSize:17]}];
         //27、切换账号偏移量
         model.switchOffsetY = @30;
         //28、隐私条款uncheckedImg选中图片
         //******************* 隐私条款***************
         model.uncheckedImg = [UIImage imageNamed:@"checkOn"];
         //29、隐私条款chexBox选中图片
         model.checkedImg = [UIImage imageNamed:@"timg.jpg"];
         //30、复选框大小（只能正方形）必须大于12*/
         model.checkboxWH = @30;
         //*31、隐私条款（包括check框）的左右边距*/
         model.appPrivacyOriginX = @80;
         //32、隐私的内容模板
         NSMutableString *demo = [NSMutableString string];
             [demo appendString:@"登录&&默认&&本界面并同意授权hdhhhhdhddh"];
             [demo appendString:@clauseOneName];
             [demo appendString:@" "];
             [demo appendString:@clauseTwoName];
             [demo appendString:@" "];
             [demo appendString:@"进行本机号码登录"];
         model.appPrivacyDemo = [[NSAttributedString alloc]initWithString:@demo attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30] ,NSForegroundColorAttributeName:UIColor.orangeColor}];
         NSAttributedString *str1 = [[NSAttributedString alloc]initWithString:@clauseOneName attributes:@{NSLinkAttributeName:@clauseOneUrl}];
         NSAttributedString *str2 = [[NSAttributedString alloc]initWithString:@clauseTwoName attributes:@{NSLinkAttributeName:@clauseTwoUrl}];
         //33、隐私条款文字内容的方向:默认是居左
         model.appPrivacyAlignment = NSTextAlignmentLeft;
         //34、隐私条款:数组对象
         model.appPrivacy = @[str1,str2];
         //35、隐私条款名称颜色（协议）
         model.privacyColor = hexColor(clauseColorBase);
         //36、隐私条款偏移量
         model.privacyOffsetY = [NSNumber numberWithFloat:(100/2)];
         //37、隐私条款check框默认状态
         model.privacyState = YES;

         //******************* 底部标识Title***************
         //38、
         model.privacySymbol = YES;
         //39、slogan偏移量
         model.sloganOffsetY =  @50;
         //40、slogan文案
         model.sloganText = [[NSAttributedString alloc]initWithString:@"sssss" attributes:@{NSForegroundColorAttributeName:UIColor.redColor,NSFontAttributeName:[UIFont systemFontOfSize:17]}];
return model;
}
//联通model设置
(ZOAUCustomModel *)createCUCCModel:(NSDictionary)themeConfigDict{
/logo图片路径
NSString logoImgPath = isExistKeyValue(themeConfigDict,@"logoImgPath") ? [themeConfigDict objectForKey:@"logoImgPath"] : @"";
//logo图片宽度
int logoWidth =  isExistKeyValue(themeConfigDict,@"logoWidth")  ? [[themeConfigDict objectForKey:@"logoWidth"] intValue]: 70);
//logo图片高度
int logoHeight =  isExistKeyValue(themeConfigDict,@"logoHeight")  ? [[themeConfigDict objectForKey:@"logoHeight"] intValue]: 70);

//用户自定义协议1标题
NSString clauseOneName = isExistKeyValue(themeConfigDict,@"clauseOneName") ? [themeConfigDict objectForKey:@"clauseOneName"] : @"开联用户协议1";
//用户自定义协议1对应的url
NSString clauseOneUrl = isExistKeyValue(themeConfigDict,@"clauseOneUrl") ? [themeConfigDict objectForKey:@"clauseOneUrl"] : @"https://www.baidu.com";
//是否显示其他登录方式
BOOL showOtherWayLogin = isExistKeyValue(themeConfigDict,@"otherWayLogin") ? [[themeConfigDict objectForKey:@"otherWayLogin"] boolValue]: NO;


        ZOAUCustomModel *mAuthPage = [[ZOAUCustomModel alloc]init];
        mAuthPage.logoImg = [UIImage imageNamed:@logoImgPath];
        mAuthPage.logoWidth = logoWidth;
        mAuthPage.logoHeight = logoHeight;

        mAuthPage.checkBoxValue = YES;
        mAuthPage.ifStopListeningAuthPageClosed = 0;
        NSArray *cuccAppPrivacy = @[@clauseOneName,@clauseOneUrl];
        NSString *text = [cuccAppPrivacy firstObject];
        NSString *url = [cuccAppPrivacy lastObject];
        mAuthPage.appFPrivacyText = text;
        mAuthPage.appFPrivacyUrl = url;
        mAuthPage.swithAccHidden = !showOtherWayLogin;
        [[ZUOAuthManager getInstance] customUIWithParams:mAuthPage topCustomViews:^(UIView *customView) {
//            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//                        button.frame = CGRectMake(250, 60, 60, 30);
//                        button.backgroundColor = UIColor.redColor;
//                        [button setTitle:@"关闭" forState:UIControlStateNormal];
//                        [button addTarget:self action:@selector(test111) forControlEvents:UIControlEventTouchUpInside];
//                        [customView addSubview:button];
        } bottomCustomViews:^(UIView *customView) {

        }];

return mAuthPage;
}
//电信model设置
(EAccountOpenPageConfig *)createCTCCModel:(NSDictionary)themeConfigDict{
 EAccountOpenPageConfig *config = [[EAccountOpenPageConfig alloc] init];
  config.nibNameOfLoginVC = @"EAccountAuthVC_dynamic";

  //默认使用亿美默认主题
  //是否使用默认主题
  BOOL useDefaultTheme = isExistKeyValue(themeConfigDict,@"useDefaultTheme") ? [[themeConfigDict objectForKey:@"useDefaultTheme"] boolValue]: YES;

  //导航栏背景色
  long navColor = isExistKeyValue(themeConfigDict,@"navColor")  ? [[themeConfigDict objectForKey:@"navColor"] longValue]: colorToHex([UIColor redColor]);
  //导航栏标题
  NSString navText = isExistKeyValue(themeConfigDict,@"navText") ? [themeConfigDict objectForKey:@"navText"] : @"统一认证登录";
  //导航栏标题颜色
  long navTextColor = isExistKeyValue(themeConfigDict,@"navTextColor")  ? [[themeConfigDict objectForKey:@"navTextColor"] longValue]: colorToHex([UIColor blackColor]) ;
  //导航栏返回按钮图片路径
  NSSString navReturnImgPath = isExistKeyValue(themeConfigDict,@"navReturnImgPath") ? [themeConfigDict objectForKey:@"navReturnImgPath"] : @"";
  //是否隐藏导航栏（默认显示）
  BOOL authNavTransparent = isExistKeyValue(themeConfigDict,@"useDefaultTheme") ? [[themeConfigDict objectForKey:@"useDefaultTheme"] boolValue]: NO;

  //logo图片路径
  NSString logoImgPath = isExistKeyValue(themeConfigDict,@"logoImgPath") ? [themeConfigDict objectForKey:@"logoImgPath"] : @"";
  //logo图片宽度
  int logoWidth =  isExistKeyValue(themeConfigDict,@"logoWidth")  ? [[themeConfigDict objectForKey:@"logoWidth"] intValue]: 300);
  //logo图片高度
  int logoHeight =  isExistKeyValue(themeConfigDict,@"logoHeight")  ? [[themeConfigDict objectForKey:@"logoHeight"] intValue]: 300);

  //登录按钮文案
  NSString logBtnText = isExistKeyValue(themeConfigDict,@"logBtnText") ? [themeConfigDict objectForKey:@"logBtnText"] : @"本机号码一键登录";
  //登录按钮文案颜色
  long logBtnTextColor = isExistKeyValue(themeConfigDict,@"logBtnTextColor")  ? [[themeConfigDict objectForKey:@"logBtnTextColor"] longValue]: colorToHex([UIColor orangeColor]);
  //登录按钮背景图片路径
  NSString logBtnImgPath = isExistKeyValue(themeConfigDict,@"logBtnImgPath") ? [themeConfigDict objectForKey:@"logBtnImgPath"] : @"";

  //用户自定义协议1标题
  NSString clauseOneName = isExistKeyValue(themeConfigDict,@"clauseOneName") ? [themeConfigDict objectForKey:@"clauseOneName"] : @"开联用户协议1";
  //用户自定义协议1对应的url
  NSString clauseOneUrl = isExistKeyValue(themeConfigDict,@"clauseOneUrl") ? [themeConfigDict objectForKey:@"clauseOneUrl"] : @"https://www.baidu.com";
  //用户自定义协议2标题
  NSString clauseTwoName = isExistKeyValue(themeConfigDict,@"clauseTwoName") ? [themeConfigDict objectForKey:@"clauseTwoName"] : @"开联用户协议2";
  //用户自定义协议2对应的url
  NSString clauseTwoUrl = isExistKeyValue(themeConfigDict,@"clauseTwoUrl") ? [themeConfigDict objectForKey:@"clauseTwoUrl"] : @"https://www.baidu.com";
  //协议字体颜色
  long clauseColorBase = isExistKeyValue(themeConfigDict,@"clauseColorBase")  ? [[themeConfigDict objectForKey:@"clauseColorBase"] longValue]: colorToHex([UIColor blackColor]);
  //自定义协议字体颜色
  long clauseColorAgree = isExistKeyValue(themeConfigDict,@"clauseColorAgree")  ? [[themeConfigDict objectForKey:@"clauseColorAgree"] longValue]: colorToHex([UIColor blackColor]);
  //是否显示其他登录方式
  BOOL showOtherWayLogin = isExistKeyValue(themeConfigDict,@"otherWayLogin") ? [[themeConfigDict objectForKey:@"otherWayLogin"] boolValue]: NO;


    // 设置电信授权页面弹出消失动画
      EACustomAnimatedTransitioning *obj = [[EACustomAnimatedTransitioning alloc] init];
      obj.targetEdge = UIRectEdgeNone;
      config.AnimatedTransitioningObj = obj;

      //    config.nibNameOfLoginVC = @"EAccountMiniAuthVC_center";
      //    config.nibNameOfLoginVC = @"EAccountMiniAuthVC_bottom";

          //    config.nibNameOfPrivacAgreementVC = @"EAccountWebViewVC_dynamic";
          //    config.EAccountBundleName = @"EAccountOpenPageResource";

              /*===========================================导航栏配置示例===========================================*/
              config.navColor = hexColor(navColor);
              config.barStyle = UIBarStyleBlack;
              config.navLineColor = [UIColor purpleColor];
              config.navText = @navText;
              config.navTextSize = 28;
              config.navTextColor = hexColor(navTextColor);
              //config.navGoBackImg_normal = [self readImageByNameFromBundle:@"logo_mini"];
              //config.navGoBackImg_highlighted = [EAccountOPSDataConfig readImageByNameFromBundle:@"logo_mini"];

              /*===========================================logo配置示例===========================================*/
              config.logoImg = [UIImage imageNamed:@logoImgPath];
              config.logoOffsetY = 200;
              config.logoHidden = NO;
              config.logoWidth = logoWidth;
              config.logoHeight = logoHeight;

              /*===========================================手机号标签配置示例========================================*/
          //    config.numberColor = [UIColor redColor];
          //    config.numberTextSize = 30;
          //    config.numFieldOffsetY = 100;

              /*===========================================中部小logo及标签配置示例======================================*/
              config.brandLabelOffsetY = 250;
              config.brandLabelTextColor = [UIColor blueColor];
              config.brandLabelTextSize = 16;

              /*===========================================登录按钮配置示例=============================================*/
              config.logBtnText = @logBtnText;
              config.logBtnOffsetY = 120;
              config.logBtnTextColor = hexColor(logBtnTextColor);
              config.logBtnWidth = 200;
              config.logBtnHeight = 30;
              config.logBtnTextSize = 12;
          ////        config.logBtnBackground = EACCOUNT_LOGINBUTTON_BACKGROUND_COLOR;
          //    config.logBtnBackground = EACCOUNT_LOGINBUTTON_BACKGROUND_IMAGES;
              config.logBtnCornerRadius = 10;
          //    config.logBtnBgColor_normal = [UIColor redColor];
          //    config.logBtnBgColor_disable = [UIColor greenColor];
          //    config.logBtnBgColor_highlighted = [UIColor blueColor];
          //    //@[激活状态的图片,失效状态的图片,高亮状态的图片]
          //    UIImage *buttongImage1 = [self readImageByNameFromBundle:@"189m"];
          //    UIImage *buttongImage2 = [self readImageByNameFromBundle:@"test2"];
          //    UIImage *buttongImage3 = [self readImageByNameFromBundle:@"btn-close"];
          //    NSArray *btnImgs = [NSArray arrayWithObjects:buttongImage1,buttongImage2,buttongImage3, nil];
          //    config.logBtnImgs = btnImgs;
          //    config.loadingImg = [self readImageByNameFromBundle:@"logo_mini"];

              /*============================================其他登录方式按钮配置示例=========================================*/
              config.otherWayLogBtnText = @"其他登录方式";
              config.otherWayLogBtnOffsetY = 150;
              config.otherWayLogBtnTextColor_normal = [UIColor blueColor];
          //    config.otherWayLogBtnTextColor_highlighted = [UIColor redColor];
              config.otherWayLogBtnTextSize = 22;
              config.otherWayLogBtnHidden = !showOtherWayLogin;

              /*=============================================勾选按钮 配置示例=============================================*/
          //    config.checkState = EACCOUNT_CHECKSTATE_UNCHECKED;
          //    config.checkBtnImg_unchecked = [self readImageByNameFromBundle:@"btn-close"];
          //    config.checkBtnImg_checked = [self readImageByNameFromBundle:@"goback_sel"];

              /*=============================================隐私协议动态配置示例===========================================*/

              // 1、合作方无自定义协议，并调用v3.7.2之前的旧接口方法：
          //    config.PALabelText = @"登录即同意《天翼账号服务与隐私协议》并授权[应用名]获本机号码";
          //    config.EAStartIndex = 5;
          //    config.EAEndIndex = 17;
          //    config.PALabelOtherTextColor = [UIColor grayColor];
          //    config.PANameColor = [UIColor blueColor];
          //    config.webNavText = @"服务与隐私协议";

              // 2、合作方《自定义协议》在右，并调用v3.7.2之前的旧接口方法：
          //    config.PALabelText = @"登录即同意《天翼账号服务与隐私协议》与《自定义协议》并授权[应用名]获本机号码";
          //    config.EAStartIndex = 5;
          //    config.EAEndIndex = 17;
          //    config.pStartIndex = 19;
          //    config.pEndIndex = 25;
          //    config.PALabelOtherTextColor = [UIColor greenColor];
          //    config.PANameColor = [UIColor redColor];
          //    config.webNavText = @"服务与隐私协议";
          //    config.PAUrl = @"http://www.baidu.com";
          //    config.pWebNavText = @"自定义协议在右";

              // 3、合作方《自定义协议》在左，并调用v3.7.2之前的旧接口方法：
          //    config.PALabelText = @"登录即同意《自定义协议》与《天翼账号服务与隐私协议》并授权[应用名]获本机号码";
          //    config.EAStartIndex = 13;
          //    config.EAEndIndex = 25;
          //    config.pStartIndex = 5;
          //    config.pEndIndex = 11;
          //    config.PALabelOtherTextColor = [UIColor greenColor];
          //    config.PANameColor = [UIColor redColor];
          //    config.webNavText = @"服务与隐私协议";
          //    config.PAUrl = @"http://www.baidu.com";
          //    config.pWebNavText = @"自定义协议在左";

              // 4、合作方无自定义协议，并调用v3.7.2接口方法：
              /** PALabelText 参数 在v3.7.2使用说明：传入完整的协议文字时，需使用下面示例的“$OAT”和“$CAT”两个字符串作为占位符
               *$OAT 为运营商协议标题占位符，SDK程序默认替换为《天翼账号服务与隐私协议》，若有其它运营商协议配置需求，可添加配置；
               *$CAT 为自定义协议标题占位符，SDK程序会替换为自定义标题字段的值；
               *[应用名] ：修改为您应用的名称
               */
          //    config.PALabelText = @"登录即同意$OAT并授权[应用名]获取本机号码";
          //    config.PALabelOtherTextColor = [UIColor purpleColor];
          //    config.PANameColor = [UIColor redColor];
          //    config.webNavText = @"服务与隐私协议";

              // 5、合作方《自定义协议》在右，并调用v3.7.2接口方法：
              /** PALabelText 参数 在v3.7.2使用说明：传入完整的协议文字时，需使用下面示例的“$OAT”和“$CAT”两个字符串作为占位符
               *$OAT 为运营商协议标题占位符，SDK程序默认替换为《天翼账号服务与隐私协议》，若有其它运营商协议配置需求，可添加配置；
               *$CAT 为自定义协议标题占位符，SDK程序会替换为自定义标题字段的值；
               *[应用名] ：修改为您应用的名称
               */
              config.PALabelText = @"登录即同意$OAT与$CAT并授权[应用名]获取本机号码";
              config.PALabelOtherTextColor = [UIColor purpleColor];
              config.PANameColor = hexColor(clauseColorBase);
              config.partnerPANameColor = hexColor(clauseColorAgree);//v3.7.2新增 单独配置合作方协议名称的颜色
              NSMutableString partnerPAName = [NSMutableString string];
                  [demo appendString:@"《"];
                  [demo appendString:@clauseOneName];
                  [demo appendString:@"》"];
              config.partnerPAName = @partnerPAName;//v3.7.2新增 合作方协议的名称
              config.webNavText = @clauseOneName;
              config.PAUrl = @clauseOneUrl;
             // config.pWebNavText = @"自定义协议在右";

              // 6、合作方《自定义协议》在左，并调用v3.7.2接口方法：
          //    config.PALabelText = @"登录即同意$CAT与$OAT并授权[应用名]获取本机号码";
          //    config.PALabelOtherTextColor = [UIColor purpleColor];
          //    config.PANameColor = [UIColor redColor];
          //    config.partnerPANameColor = [UIColor greenColor];//v3.7.2新增 单独配置合作方协议名称的颜色
          //    config.partnerPAName = @"《自定义协议》";//v3.7.2新增 合作方协议的名称
          //    config.webNavText = @"服务与隐私协议";
          //    config.PAUrl = @"http://www.baidu.com";
          //    config.pWebNavText = @"自定义协议在左";

              ////若有其它运营商协议配置需求，可添加以下配置。SDK检测到异网用户会显示相应的协议标题，配置示例：
          //    config.chinaMobileTitle = @"《中国移动认证服务协议》";  //设置中国移动隐私协议标题
          //    config.chinaMobileUrl = @"https://wap.cmpassport.com/resources/html/contract.html";  //设置中国移动隐私协议wap页面地址
          //    config.chinaUnicomTitle = @"《中国联通服务条款及隐私协议》";  //设置中国联通隐私协议标题
          //    config.chinaUnicomUrl = @"https://ms.zzx9.cn/html/oauth/protocol.html"; //设置中国联通隐私协议wap页面地址

              //其余协议标签设置
          //    config.PALabelTextSize = 12;
              config.PALabelTextLineSpacing = 4;
          //    config.checkBtnOffsetY = 60;
          //    config.PALabelOffsetY = 60;

              /*==========================================全屏页面弹窗隐私协议动态配置示例============================================*/
              //注意：Mini框无弹窗弹出，无须配置弹窗隐私协议

              // 1、弹窗合作方无自定义协议，并调用v3.7.2之前的旧接口方法：
          //    config.dialogPALabelText = @"登录即同意《天翼账号服务与隐私协议》";
          //    config.dialogEAStartIndex = 5;
          //    config.dialogEAEndIndex = 17;
          //    config.dialogPAOtherTextColor = [UIColor grayColor];
          //    config.dialogPANameColor = [UIColor blueColor];
          //    config.webNavText = @"服务与隐私协议";

              // 2、弹窗合作方《自定义协议》在右，并调用v3.7.2之前的旧接口方法：
          //    config.dialogPALabelText = @"登录即同意《天翼账号服务与隐私协议》与《自定义协议》";
          //    config.dialogEAStartIndex = 5;
          //    config.dialogEAEndIndex = 17;
          //    config.dialogPStartIndex = 19;
          //    config.dialogPEndIndex = 25;
          //    config.dialogPAOtherTextColor = [UIColor greenColor];
          //    config.dialogPANameColor = [UIColor redColor];
          //    config.webNavText = @"服务与隐私协议";
          //    config.PAUrl = @"http://www.baidu.com";
          //    config.pWebNavText = @"自定义协议在右";

              // 3、弹窗合作方《自定义协议》在左，并调用v3.7.2之前的旧接口方法：
          //    config.dialogPALabelText = @"登录即同意《自定义协议》与《天翼账号服务与隐私协议》";
          //    config.dialogEAStartIndex = 13;
          //    config.dialogEAEndIndex = 25;
          //    config.dialogPStartIndex = 5;
          //    config.dialogPEndIndex = 11;
          //    config.dialogPAOtherTextColor = [UIColor greenColor];
          //    config.dialogPANameColor = [UIColor redColor];
          //    config.webNavText = @"服务与隐私协议";
          //    config.PAUrl = @"http://www.baidu.com";
          //    config.pWebNavText = @"自定义协议在左";

              // 4、合作方无自定义协议，并调用v3.7.2接口方法：
              /** PALabelText 参数 在v3.7.2使用说明：传入完整的协议文字时，需使用下面示例的“$OAT”和“$CAT”两个字符串作为占位符
               *$OAT 为运营商协议标题占位符，SDK程序默认替换为《天翼账号服务与隐私协议》，若有其它运营商协议配置需求，可添加配置；
               *$CAT 为自定义协议标题占位符，SDK程序会替换为自定义标题字段的值；
               *[应用名] ：修改为您应用的名称
               */
          //    config.dialogPALabelText = @"登录即同意$OAT";
          //    config.dialogPAOtherTextColor = [UIColor purpleColor];
          //    config.dialogPANameColor = [UIColor yellowColor];
          //    config.webNavText = @"服务与隐私协议";

              // 5、合作方《自定义协议》在右，并调用v3.7.2接口方法：
              /** PALabelText 参数 在v3.7.2使用说明：传入完整的协议文字时，需使用下面示例的“$OAT”和“$CAT”两个字符串作为占位符
               *$OAT 为运营商协议标题占位符，SDK程序默认替换为《天翼账号服务与隐私协议》，若有其它运营商协议配置需求，可添加配置；
               *$CAT 为自定义协议标题占位符，SDK程序会替换为自定义标题字段的值；
               *[应用名] ：修改为您应用的名称
               */
             // config.dialogPALabelText = @"登录即同意$OAT与$CAT";
             // config.dialogPAOtherTextColor = [UIColor purpleColor];
             // config.dialogPANameColor = [UIColor redColor];
             // config.dialogPartnerPANameColor = [UIColor greenColor];//v3.7.2新增 单独配置合作方协议名称的颜色
             // config.partnerPAName = @"《合作方自定义协议》";//v3.7.2新增 合作方协议的名称
             // config.webNavText = @"服务与隐私协议";
             // config.PAUrl = @"http://www.baidu.com";
             // config.pWebNavText = @"自定义协议在右";

              // 6、合作方《自定义协议》在左，并调用v3.7.2接口方法：
          //    config.dialogPALabelText = @"登录即同意$CAT与$OAT";
          //    config.dialogPAOtherTextColor = [UIColor purpleColor];
          //    config.dialogPANameColor = [UIColor redColor];
          //    config.dialogPartnerPANameColor = [UIColor greenColor];//v3.7.2新增 单独配置合作方协议名称的颜色
          //    config.partnerPAName = @"《自定义协议》";//v3.7.2新增 合作方协议的名称
          //    config.webNavText = @"服务与隐私协议";
          //    config.PAUrl = @"http://www.baidu.com";
          //    config.pWebNavText = @"自定义协议在左";

              //其余弹窗协议标签设置
          //    config.dialogPALabelTextSize = 12;
          //    config.dialogPALabelTextLineSpacing = 5;

              /*==============================================迷你登录框动态配置示例============================================*/
          //    config.miniBoxYPosition = EACCOUNT_MINI_POSITION_TOP;
          //    config.miniBoxWidth = 100;
          //    config.miniBoxHeight = 200;


 return config;
}
@end
