//
//  YQSlidMenuController.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/5/20.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "YQSlideMenuController.h"

static CGFloat const LeftMarginGesture = 45.0f;
static CGFloat const MinScaleContentView = 0.8f;
static CGFloat const MoveDistanceMenuView = 100.0f;
static CGFloat const MinScaleMenuView = 0.8f;
static double const DurationAnimation = 0.3f;
@interface YQSlideMenuController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *menuViewContainer;
@property (nonatomic, strong) UIView *contentViewContainer;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIView *gestureRecognizerView;
@property (nonatomic, strong) UIPanGestureRecognizer *edgePanGesture;

@property (strong, readwrite, nonatomic) IBInspectable UIColor *contentViewShadowColor;
@property (assign, readwrite, nonatomic) IBInspectable CGSize contentViewShadowOffset;
@property (assign, readwrite, nonatomic) IBInspectable CGFloat contentViewShadowOpacity;
@property (assign, readwrite, nonatomic) IBInspectable CGFloat contentViewShadowRadius;

@property (assign, nonatomic) CGFloat realContentViewVisibleWidth;

@property (assign, nonatomic) CGFloat contentViewScale;

@property (nonatomic,assign) BOOL menuHidden;

@end

@implementation YQSlideMenuController


- (id)initWithContentViewController:(UIViewController *)contentViewController leftMenuViewController:(UIViewController *)leftMenuViewController{
    if(self = [super init]){
        self.contentViewController = contentViewController;
        self.leftMenuViewController = leftMenuViewController;
        [self prepare];
    }
    return self;
}

- (void)prepare{
    _menuViewContainer = [[UIView alloc] init];
    _contentViewContainer = [[UIView alloc] init];
    _gestureRecognizerView = [[UIView alloc] init];
    _gestureRecognizerView.hidden = YES;//Fix 150922 初始没有隐藏导致rootController上手势无法正确识别
    _gestureRecognizerView.backgroundColor = [UIColor clearColor];
    _contentViewShadowColor = [UIColor blackColor];
    _contentViewShadowOffset = CGSizeZero;
    _contentViewShadowOpacity = 0.4f;
    _contentViewShadowRadius = 5.0f;
    _contentViewVisibleWidth = 120.0f;
//    _realContentViewVisibleWidth = _contentViewVisibleWidth/MinScaleContentView;
    _contentViewScale = 1.0f;
    _menuHidden = YES;
}
- (void)awakeFromNib{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.realContentViewVisibleWidth = self.contentViewVisibleWidth/MinScaleContentView;
    // Do any additional setup after loading the view.
    self.backgroundImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.image = self.backgroundImage;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView;
    });
    
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.menuViewContainer];
    [self.view addSubview:self.contentViewContainer];
    
    self.menuViewContainer.frame = self.view.bounds;
    self.contentViewContainer.frame = self.view.bounds;
    self.gestureRecognizerView.frame = self.view.bounds;
    
    self.menuViewContainer.backgroundColor = [UIColor clearColor];
    
    if (self.leftMenuViewController) {
        [self addChildViewController:self.leftMenuViewController];
        self.leftMenuViewController.view.frame = self.view.bounds;
        self.leftMenuViewController.view.backgroundColor = [UIColor clearColor];
        self.leftMenuViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.menuViewContainer addSubview:self.leftMenuViewController.view];
        [self.leftMenuViewController didMoveToParentViewController:self];
    }
 
    NSAssert(self.contentViewController, @"内容视图不能为空");
    self.contentViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addChildViewController:self.contentViewController];
    self.contentViewController.view.frame = self.view.bounds;
    [self.contentViewContainer addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
    
    
//    UIScreenEdgePanGestureRecognizer *panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
//    panGesture.edges = UIRectEdgeLeft;
    self.edgePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    self.edgePanGesture.delegate = self;
    [self.contentViewContainer addGestureRecognizer:self.edgePanGesture];
    
    [self.contentViewContainer addSubview:self.gestureRecognizerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.gestureRecognizerView addGestureRecognizer:tap];
    
    [self updateContentViewShadow];
    
}

- (void)showViewController:(UIViewController *)viewController{
    NSAssert([self.contentViewController isKindOfClass:[UINavigationController class]], @"住内容视图控制器不是UINavigationController");
    
    [((UINavigationController *)self.contentViewController) pushViewController:viewController animated:NO];
    [self hideMenu];
}
- (void)hideMenu{
    if(!self.menuHidden){
        [self showMenu:NO];
    }
}
- (void)showMenu{
    if(self.menuHidden){
        [self showMenu:YES];
    }
}
#pragma method overwrite
- (void)setBackgroundImage:(UIImage *)backgroundImage{
    if(_backgroundImage != backgroundImage){
        _backgroundImage = backgroundImage;
        self.backgroundImageView.image = backgroundImage;
    }
}

#pragma custom selector

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)recongnizer{
    if(!self.menuHidden){
        [self hideMenu];
    }
}

- (void)panGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)recognizer{
    
    CGPoint point = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self updateContentViewShadow];
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
        CGFloat menuVisibleWidth = self.view.bounds.size.width-self.realContentViewVisibleWidth;
        CGFloat delta = self.menuHidden ? point.x/menuVisibleWidth : (menuVisibleWidth+point.x)/menuVisibleWidth;

        CGFloat scale = 1-(1-MinScaleContentView)*delta;
        CGFloat menuScale = MinScaleMenuView + (1-MinScaleMenuView)*delta;
        if(self.menuHidden){
            //以内容视图最小缩放为界限
            if(scale < MinScaleContentView){//A
                self.contentViewContainer.transform = CGAffineTransformMakeTranslation(menuVisibleWidth, 0);
                self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform,MinScaleContentView,MinScaleContentView);
                self.contentViewScale = MinScaleContentView;
                self.menuViewContainer.transform = CGAffineTransformMakeScale(1, 1);
                self.menuViewContainer.transform = CGAffineTransformTranslate(self.menuViewContainer.transform, 0, 0);
                
            }else{//大于最小界限又分大于等于1和小于1两种情况
               
                if(scale < 1){//B
                    self.contentViewContainer.transform = CGAffineTransformMakeTranslation(point.x, 0);
                    self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform,scale, scale);
                    self.contentViewScale = scale;
                    self.menuViewContainer.transform = CGAffineTransformMakeScale(menuScale, menuScale);
                    self.menuViewContainer.transform = CGAffineTransformTranslate(self.menuViewContainer.transform, -MoveDistanceMenuView *(1-delta), 0);
                }else{//C
                    self.contentViewContainer.transform = CGAffineTransformMakeTranslation(0, 0);
                    self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform,1, 1);
                    self.contentViewScale = 1;
                    self.menuViewContainer.transform = CGAffineTransformMakeScale(MinScaleMenuView, MinScaleMenuView);
                    self.menuViewContainer.transform = CGAffineTransformTranslate(self.menuViewContainer.transform, -MoveDistanceMenuView, 0);
                }

            }
            
        }else{
            
            if(scale > 1){//D
                self.contentViewContainer.transform = CGAffineTransformMakeTranslation(0, 0);
                self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform,1,1);
                self.contentViewScale = 1;
                self.menuViewContainer.transform = CGAffineTransformMakeScale(MinScaleMenuView, MinScaleMenuView);
                self.menuViewContainer.transform = CGAffineTransformTranslate(self.menuViewContainer.transform, -MoveDistanceMenuView, 0);
            }else{
                if(scale>MinScaleContentView){//E
                    self.contentViewContainer.transform = CGAffineTransformMakeTranslation(point.x+menuVisibleWidth, 0);
                    self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform,scale, scale);
                    self.contentViewScale = scale;
                    self.menuViewContainer.transform = CGAffineTransformMakeScale(menuScale, menuScale);
                    self.menuViewContainer.transform = CGAffineTransformTranslate(self.menuViewContainer.transform, -MoveDistanceMenuView * (1-delta), 0);
                }else{//F
                    self.contentViewContainer.transform =CGAffineTransformMakeTranslation(self.view.bounds.size.width-self.realContentViewVisibleWidth, 0);
                    self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform,MinScaleContentView, MinScaleContentView);
                    self.contentViewScale = MinScaleContentView;
                    self.menuViewContainer.transform = CGAffineTransformMakeScale(1, 1);
                    self.menuViewContainer.transform = CGAffineTransformTranslate(self.menuViewContainer.transform, 0, 0);
                }
            }
        }
        
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
//        [self showMenu:(self.contentViewContainer.frame.origin.x > self.view.bounds.size.width/2)];
        [self showMenu:(self.contentViewScale < 1-(1-MinScaleContentView)/2)];
    }
}
- (void)showMenu:(BOOL)show{
    NSTimeInterval duration  = show ? (self.contentViewScale-MinScaleContentView)/(1-MinScaleContentView)*DurationAnimation : (1 - (self.contentViewScale-MinScaleContentView)/(1-MinScaleContentView))*DurationAnimation;
    
    [UIView animateWithDuration:duration animations:^{
        if(show){
            self.contentViewContainer.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width-self.realContentViewVisibleWidth, 0);
            self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform,MinScaleContentView, MinScaleContentView);
            self.menuViewContainer.transform = CGAffineTransformIdentity;
            self.contentViewScale = MinScaleContentView;
        }else{

            self.contentViewContainer.transform = CGAffineTransformIdentity;
            self.contentViewScale = 1;
            self.menuViewContainer.transform = CGAffineTransformMakeScale(MinScaleMenuView, MinScaleMenuView);
            self.menuViewContainer.transform = CGAffineTransformTranslate(self.menuViewContainer.transform, -MoveDistanceMenuView, 0);
        }
    } completion:^(BOOL finished) {
        self.menuHidden = !show;
        self.gestureRecognizerView.hidden = !show;
    }];
}

#pragma method assist
- (void)updateContentViewShadow
{
   
    CALayer *layer = self.contentViewContainer.layer;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:layer.bounds];
    layer.shadowPath = path.CGPath;
    layer.shadowColor = self.contentViewShadowColor.CGColor;
    layer.shadowOffset = self.contentViewShadowOffset;
    layer.shadowOpacity = self.contentViewShadowOpacity;
    layer.shadowRadius = self.contentViewShadowRadius;
}

#pragma gesture delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    
    if(self.contentViewController.childViewControllers.count < 2){//这样只有在根视图控制器上起作用
        CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
        if(self.menuHidden){
            if(point.x <= LeftMarginGesture){NSLog(@"A");
                return YES;
            }else{
                NSLog(@"B");
            }
        }else{NSLog(@"C");
            return YES;
        }
    }
//    if(gestureRecognizer == self.edgePanGesture){
//        NSLog(@"NNNNNNNNNNN------ %@",gestureRecognizer.view);
//    }
    return !(gestureRecognizer == self.edgePanGesture);

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    NSLog(@"otherGesute = %@",otherGestureRecognizer);
    if(gestureRecognizer == self.edgePanGesture){NSLog(@"AAAA");
        return YES;
    }NSLog(@"BBBB");
    return  NO;
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
