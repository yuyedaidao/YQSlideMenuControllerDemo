//
//  UIViewController+YQSlideMenu.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/5/26.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "UIViewController+YQSlideMenu.h"

@implementation UIViewController (YQSlideMenu)
- (YQSlideMenuController *)slideMenuController
{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[YQSlideMenuController class]]) {
            return (YQSlideMenuController *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}
@end
