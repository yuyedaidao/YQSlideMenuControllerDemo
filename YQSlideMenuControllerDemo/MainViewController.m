//
//  MainViewController.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/5/26.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "MainViewController.h"
#import "OneViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title =@"Main";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(push:)];
    self.navigationItem.rightBarButtonItem = rightItem;
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
