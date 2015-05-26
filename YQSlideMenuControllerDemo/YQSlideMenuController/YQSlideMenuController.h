//
//  YQSlidMenuController.h
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/5/20.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQSlideMenuController : UIViewController

@property (nonatomic,strong) UIViewController *leftMenuViewController;
@property (nonatomic,strong) UIViewController *contentViewController;
@property (nonatomic,strong) UIImage *backgroundImage;

/**
 *  菜单打开时原来内容页露在侧边的最大宽，注意是指缩放完成之后的
 */
@property (nonatomic,assign) CGFloat contentViewVisibleWidth;

- (id)initWithContentViewController:(UIViewController *)contentViewController
             leftMenuViewController:(UIViewController *)leftMenuViewController;

- (void)showViewController:(UIViewController *)viewController;
- (void)hideMenu;
- (void)showMenu;
@end
