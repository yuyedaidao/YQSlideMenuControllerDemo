//
//  YQTabBarItem.h
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/7/1.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YQTabBarItemState) {
    YQTabBarItemStateNormal,
    YQTabBarItemStateHighlight,
    YQTabBarItemStateSelect,
};

@interface YQTabBarItem : UIControl
- (instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage highlightedImage:(UIImage *)highlightedImage;

@property (nonatomic, strong, readonly) UIImageView *barImgView;
///这个针对当前项目专门设置，用于“+”旋转
@property (nonatomic, strong) UIView *bgTopView;
//@property (nonatomic, strong) void (^didTouchBlock)(void);

@property (nonatomic, assign) YQTabBarItemState itemState;

@end
