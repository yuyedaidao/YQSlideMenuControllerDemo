//
//  TwoViewController.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/5/26.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureAction:)];
    [self.view addGestureRecognizer:pressGesture];
}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.imgView.image = [UIImage imageNamed:@"dog2"];
    } else if (gesture.state == UIGestureRecognizerStateEnded){
        self.imgView.image = [UIImage imageNamed:@"dog"];
    }
}

- (NSArray <id <UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *action = [UIPreviewAction actionWithTitle:@"哈哈" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"什么也不干");
    }];
    return @[action];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
