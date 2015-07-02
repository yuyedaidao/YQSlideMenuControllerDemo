//
//  AppDelegate.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/5/20.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "YQSlideMenuController.h"
#import "LeftMenuController.h"
#import "MainViewController.h"
#import "OneViewController.h"
#import "YQTabBarController.h"


@interface AppDelegate ()<YQTabBarViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    MainViewController *contentViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
   
    NSMutableArray *viewControllers = [@[] mutableCopy];
    for (int i = 0; i<3; i++) {
        MainViewController *vc = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        vc.title = [NSString stringWithFormat:@"title %d",i];
        [viewControllers addObject:vc];
    }
    OneViewController *oneVC = [[OneViewController alloc] initWithNibName:@"OneViewController" bundle:nil];
    [viewControllers addObject:oneVC];
    YQTabBarController *contentViewController  = [[YQTabBarController alloc] initWithViewControllers:viewControllers  reservedIndexs:@[[NSNumber numberWithInteger:2]]];
    contentViewController.tabBarViewDelegate = self;
   
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentViewController];
    LeftMenuController  *leftMenuViewController = [[LeftMenuController alloc] init];
    YQSlideMenuController *sideMenuController = [[YQSlideMenuController alloc] initWithContentViewController:navigationController
                                                                    leftMenuViewController:leftMenuViewController];
    sideMenuController.backgroundImage = [UIImage imageNamed:@"slide_bg"];
  
    sideMenuController.currentVCDelegate = contentViewController;
    self.window.rootViewController = sideMenuController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;

}

- (CGSize)tabBarView:(YQTabBarView *)tabBarView sizeForItemAtIndex:(NSInteger)index{
    return CGSizeMake(40, 40);
};
- (YQTabBarItem *)tabBarView:(YQTabBarView *)tabBarView itemForIndex:(NSInteger)index{

    YQTabBarItem *item = [[YQTabBarItem alloc] initWithNormalImage:[UIImage imageNamed:@"home_button_words_a"] selectedImage:[UIImage imageNamed:@"home_button_interview_a"] highlightedImage:[UIImage imageNamed:@"home_button_interview_a"]];
    return item;
}
- (BOOL)tabBarView:(YQTabBarView *)tabBarView shouldSelectItemAtIndex:(NSInteger)index{
    return YES;
}
- (void)tabBarView:(YQTabBarView *)tabBarView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"did selected Item %d",index);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
