//
//  YQTabBarView.h
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/6/30.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQTabBarItem.h"

@class YQTabBarView;

@protocol YQTabBarViewDelegate <NSObject>

/**
 *这些是暴露给开发者的
 */
//一般可以直接返回UIButton,如果有需要定制的Item可以自己定义
- (YQTabBarItem *)tabBarView:(YQTabBarView *)tabBarView itemForIndex:(NSInteger)index;

///这其实是显示的图片的大小
- (CGSize)tabBarView:(YQTabBarView *)tabBarView sizeForItemAtIndex:(NSInteger)index;
- (BOOL)tabBarView:(YQTabBarView *)tabBarView shouldSelectItemAtIndex:(NSInteger)index;
- (void)tabBarView:(YQTabBarView *)tabBarView didSelectItemAtIndex:(NSInteger)index;

@optional
- (NSInteger)defaultSelectIndex;

@end

@interface YQTabBarView : UIView

- (instancetype)initWithItemCount:(NSInteger)count;
///用于YQTabBarController,不面向开发者
@property (nonatomic, strong) void (^tabBarItemClickedBlock)(NSInteger index);
@property (nonatomic, strong) UIImage *backgroundImage;
//@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) id<YQTabBarViewDelegate> delegate;
- (void)loadItems;

- (YQTabBarItem *)tabBarItemForIndex:(NSInteger)index;
@end
