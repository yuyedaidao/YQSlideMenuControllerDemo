//
//  UIViewController+YQTabBar.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/7/2.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "UIViewController+YQTabBar.h"

@implementation UIViewController (YQTabBar)
- (YQTabBarController *)yq_tabBarController{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[YQTabBarController class]]) {
            return (YQTabBarController *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;

}
@end
