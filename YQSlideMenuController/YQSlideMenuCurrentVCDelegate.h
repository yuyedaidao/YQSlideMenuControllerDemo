//
//  YQSlideMenuCurrentVCDelegate.h
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/7/2.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

/**
    针对自定义的添加了childViewController的容器类视图控制器
 
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol YQSlideMenuCurrentVCDelegate <NSObject>

- (UIViewController *)yq_currentViewController;

@end
