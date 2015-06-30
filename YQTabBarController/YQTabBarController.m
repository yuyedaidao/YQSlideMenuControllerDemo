//
//  YQTabBarController.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/6/27.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "YQTabBarController.h"

@interface YQTabBarController (){
    int  *indexType;
}

@property (strong, nonatomic) UIView *contentViewContainer;
@property (strong, nonatomic) UIView *tabBarView;
@property (strong, nonatomic) NSArray *viewControllers;


@end


@implementation YQTabBarController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers reservedIndexs:(NSArray *)indexs{
    NSAssert(viewControllers, @"您的viewController不能为空");
    if(indexs.count){
        [indexs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSAssert1([obj integerValue]<viewControllers.count+indexs.count, @"您的预留index %@ 不合法",obj);
        }];
    }
    //先判断是否符合规范
    if(self = [super init]){
        NSInteger count = viewControllers.count+indexs.count;
        indexType = malloc(sizeof(int)*count);
        NSLog(@"indexType count = %ld",sizeof(indexType));
        _viewControllers = viewControllers;
        memset(indexType, 0, (int)sizeof(indexType));
        [indexs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            indexType[[obj integerValue]] = -1;
        }];
        __block int flag = 0;
        [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            for (int i = flag;i < count; i++ ) {
                if(indexType[i]==0){
                    indexType[i]=(int)idx;
                    flag = i+1;
                    break;
                }
            }
        }];
        
        for (int i = 0 ; i<count; i++) {
            NSLog(@"indexTypes %d %d",i,indexType[i]);
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}


- (void)selectViewControllerAtIndex:(NSInteger)index{
    if(indexType[index] < 0){
        //这里是按钮没有子视图的调整
    }else{
        //
        UIViewController *toViewController = self.viewControllers[indexType[index]];
    }
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
