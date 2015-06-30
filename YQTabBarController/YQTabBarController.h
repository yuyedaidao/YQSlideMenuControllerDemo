//
//  YQTabBarController.h
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/6/27.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQTabBarController : UIViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;
/**
 *  生成有预留位置的TabBarControll实例
 *
 *  @param viewControllers viewControllers description
 *  @param indexs          在这些index位置预留按钮事件，不添加viewController
 *
 *  @return return value description
 */
- (instancetype)initWithViewControllers:(NSArray *)viewControllers reservedIndexs:(NSArray *)indexs;

//- (void)didClickedItemAtIndex:(NSInteger)index;
@property (nonatomic ,strong) BOOL (^shouldSeletItemBlock)(NSInteger index);
@property (nonatomic ,strong) void (^willSeletItemBlock)(NSInteger index);
@property (nonatomic ,strong) void (^didSeletItemBlock)(NSInteger index);

@end
