//
//  MainViewController.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/5/26.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "MainViewController.h"
#import "OneViewController.h"
#import "YQTabBarItem.h"
#import "UIViewController+YQTabBar.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    imageView.image = [UIImage imageNamed:@"slide_bg"];
//    [self.view addSubview:imageView];
//    
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-self.view.bounds.size.width, 0)];
//    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width, 0)];
//    animation.repeatCount = INT32_MAX;
//    animation.duration = 3.0f;
//    [imageView.layer addAnimation:animation forKey:@"animation"];
//    UITabBarController
    
    YQTabBarItem *item = [[YQTabBarItem alloc] initWithNormalImage:[UIImage imageNamed:@"home_button_interview_a"] selectedImage:[UIImage imageNamed:@"home_button_interview_a"] highlightedImage:nil];
    [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:item];
    item.frame = CGRectMake(160, 100, 50, 50);
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSInteger t = arc4random()%5;
    self.parentViewController.title = [NSString stringWithFormat:@"title%ld",(long)t];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Next%ld",(long)t] style:UIBarButtonItemStylePlain target:self action:@selector(push:)];
    self.parentViewController.navigationItem.rightBarButtonItem = rightItem;
}
- (void)itemClicked:(YQTabBarItem *)item{

    static int i = 0;
    NSLog(@"tabBar = %@",self.yq_tabBarController);
    [self.yq_tabBarController showTabBarView:i++%2]; 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma IBAction
- (IBAction)push:(id)sender {
    OneViewController *one = [[OneViewController alloc] initWithNibName:@"OneViewController" bundle:nil];
    [self.navigationController pushViewController:one animated:YES];
}
- (IBAction)present:(id)sender {
    OneViewController *one = [[OneViewController alloc] initWithNibName:@"OneViewController" bundle:nil];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:one] animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
