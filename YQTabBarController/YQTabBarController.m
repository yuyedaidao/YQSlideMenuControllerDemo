//
//  YQTabBarController.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/6/27.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "YQTabBarController.h"


static CGFloat YQTabBarHieght = 50.0f;

@interface YQTabBarController (){
    int  *indexType;
}

@property (strong, nonatomic) UIView *contentViewContainer;
@property (strong, nonatomic) UIView *tabBarView;
@property (strong, nonatomic) NSArray *viewControllers;
@property (weak, nonatomic) UIViewController *currentViewController;
@property (assign, nonatomic) NSInteger indexCount;
@end


@implementation YQTabBarController
- (instancetype)initWithViewControllers:(NSArray *)viewControllers{
    return [self initWithViewControllers:viewControllers reservedIndexs:nil];
}
- (instancetype)initWithViewControllers:(NSArray *)viewControllers reservedIndexs:(NSArray *)indexs{
    NSAssert(viewControllers, @"您的viewController不能为空");
    if(indexs.count){
        [indexs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSAssert1([obj integerValue]<viewControllers.count+indexs.count, @"您的预留index %@ 不合法",obj);
        }];
    }
    //先判断是否符合规范
    if(self = [super init]){
        self.indexCount = viewControllers.count+indexs.count;
        indexType = malloc(sizeof(int)*self.indexCount);
        _viewControllers = viewControllers;
        //归零
        memset(indexType, 0, sizeof(int)*self.indexCount);
        [indexs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            indexType[[obj integerValue]] = -1;
        }];
        __block int flag = 0;
        [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            for (int i = flag;i < self.indexCount; i++ ) {
                if(indexType[i]==0){
                    indexType[i]=(int)idx;
                    flag = i+1;
                    break;
                }
            }
        }];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepareViews];

    NSInteger firstVCIndex = 0;
    for (int i = 0; i < self.indexCount; i++) {
        if(indexType[i] >= 0){
            firstVCIndex = i;
            break;
        }
    }
    [self selectViewControllerAtIndex:firstVCIndex];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
}
#pragma mark self hander
- (void)prepareViews{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentViewContainer = [[UIView alloc] init];
    [self.view addSubview:self.contentViewContainer];
    
    self.tabBarView = [[UIView alloc] init];
    [self.view addSubview:self.tabBarView];
    
    [self.contentViewContainer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tabBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewsDic = NSDictionaryOfVariableBindings(self.view,_contentViewContainer,_tabBarView);
    
    NSArray *constraint_one_array = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_contentViewContainer]-(0)-|" options:0 metrics:nil views:viewsDic];
    NSArray *constraint_two_array = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[_contentViewContainer]-(0)-[_tabBarView(tabBarHeight)]-(0)-|" options:0 metrics:@{@"tabBarHeight":@(YQTabBarHieght)} views:viewsDic];
    [self.view addConstraints:constraint_one_array];
    [self.view addConstraints:constraint_two_array];
    
    NSArray *constraint_three_array = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[_tabBarView]-(0)-|" options:0 metrics:nil views:viewsDic];
    [self.view addConstraints:constraint_three_array];
    

}

#pragma mark open api
- (void)selectViewControllerAtIndex:(NSInteger)index{
    NSAssert(index<self.indexCount, @"index 超出了范围");
    
    BOOL shouldSelect = YES;
    if(self.shouldSeletItemBlock){
        shouldSelect = self.shouldSeletItemBlock(index);
    }
    if(shouldSelect){
        if(self.willSeletItemBlock){
            self.willSeletItemBlock(index);
        }
        if(indexType[index] < 0){
            //这里是按钮没有子视图的调整
        }else{
            //
            UIViewController *fromViewController = self.currentViewController;
            UIViewController *toViewController = self.viewControllers[indexType[index]];
            
            if(!fromViewController){
                [self addChildViewController:toViewController];
                [self.contentViewContainer addSubview:toViewController.view];
                toViewController.view.frame = self.contentViewContainer.bounds;
                [toViewController didMoveToParentViewController:self];
                
            }else{
                [fromViewController willMoveToParentViewController:nil];
                [self addChildViewController:toViewController];
                [self.contentViewContainer addSubview:toViewController.view];
                toViewController.view.frame = self.contentViewContainer.bounds;
                [fromViewController.view removeFromSuperview];
                [fromViewController removeFromParentViewController];
            }
            
        }
        if(self.didSeletItemBlock){
            self.didSeletItemBlock(index);
        }

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
