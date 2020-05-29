//
//  UniLogin.h
//  UniLogin
//
//  Created by 乔春晓 on 2019/10/10.
//  Copyright © 2019 乔春晓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YMCustomConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface UniLogin : NSObject

/// 单例
+(instancetype)shareInstance;

/// 登录方法
/// @param currectVC 当前控制器
/// @param customConfig 配置参数
/// @param appId 分配的appId
/// @param secretKey 分配的密钥
/// @param complete 完成回调
- (void)loginWithViewControler:(UIViewController *)currectVC customConfig:(YMCustomConfig *)customConfig appId:(NSString *)appId secretKey:(NSString *)secretKey complete:(void(^)(NSString * _Nullable mobile, NSString* _Nullable msg))complete;

/// 关闭授权页面
/// @param flag 关闭页面动画开关 （对移动联通可行，电信依然依赖配置参数的设置）
/// @param completion 回调（仅用于移动、联通）
- (void)closeUniLoginViewControlerAnimated:(BOOL)flag completion:(void (^ __nullable)(void))completion;

/// 获取当前SDK版本号
- (NSString *)getVersion;

@end
NS_ASSUME_NONNULL_END
