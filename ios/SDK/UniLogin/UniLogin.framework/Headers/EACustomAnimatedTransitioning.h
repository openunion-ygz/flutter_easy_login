//
//  EACustomAnimatedTransitioning.h
//  EAccountOpenPageSDK
//
//  Created by Reticence Lee on 2019/11/15.
//  Copyright © 2019 21CN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EACustomAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UIRectEdge targetEdge;

@end

NS_ASSUME_NONNULL_END
