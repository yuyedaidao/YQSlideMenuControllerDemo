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
static CGFloat const MinTrigerSpeed = 1000.0f;
@interface YQSlideMenuController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *menuViewContainer;
@property (nonatomic, strong) UIView *contentViewContainer;
@property (nonatomic, strong) UIView *gestureRecognizerView;
@property (nonatomic, strong) UIPanGestureRecognizer *edgePanGesture;

@property (strong, readwrite, nonatomic) IBInspectable UIColor *contentViewShadowColor;
@property (assign, readwrite, nonatomic) IBInspectable CGSize contentViewShadowOffset;
@property (assign, readwrite, nonatomic) IBInspectable CGFloat contentViewShadowOpacity;
@property (assign, readwrite, nonatomic) IBInspectable CGFloat contentViewShadowRadius;

@property (assign, nonatomic) CGFloat realContentViewVisibleWidth;

@property (assign, nonatomic) CGFloat contentViewScale;

@property (assign, nonatomic) BOOL menuHidden;
@property (assign, nonatomic) BOOL menuMoving;

@property (strong, nonatomic) NSArray *priorGestures;
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
    _gestureRecognizerView.hidden = YES;
    _gestureRecognizerView.backgroundColor = [UIColor clearColor];
    _contentViewShadowColor = [UIColor blackColor];
    _contentViewShadowOffset = CGSizeZero;
    _contentViewShadowOpacity = 0.4f;
    _contentViewShadowRadius = 5.0f;
    _contentViewVisibleWidth = 120.0f;
    _contentViewScale = 1.0f;
    _menuHidden = YES;
    _scaleContent = YES;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            _priorGestures = @[[UILongPressGestureRecognizer class], NSClassFromString(@"_UIPreviewGestureRecognizer"),NSClassFromString(@"_UIRevealGestureRecognizer")];
        } else {
            _priorGestures = @[[UILongPressGestureRecognizer class]];
        }
    } else {
        _priorGestures = @[[UILongPressGestureRecognizer class]];
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.realContentViewVisibleWidth = _scaleContent ? self.contentViewVisibleWidth/MinScaleContentView : self.contentViewVisibleWidth;
    [self.view addSubview:self.menuViewContainer];
    [self.view addSubview:self.contentViewContainer];
    
    self.menuViewContainer.frame = self.view.bounds;
    self.contentViewContainer.frame = self.view.bounds;
    self.gestureRecognizerView.frame = self.view.bounds;
    
    if (self.leftMenuViewController) {
        [self addChildViewController:self.leftMenuViewController];
        self.leftMenuViewController.view.frame = self.view.bounds;
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
    
    
    self.edgePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    self.edgePanGesture.delegate = self;
    [self.contentViewContainer addGestureRecognizer:self.edgePanGesture];
    
    [self.contentViewContainer addSubview:self.gestureRecognizerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.gestureRecognizerView addGestureRecognizer:tap];

    [self updateContentViewShadow];
    
    
}

- (void)showViewController:(UIViewController *)viewController{
    if ([self.contentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.contentViewController;
        [nav pushViewController:viewController animated:NO];
        [self hideMenu];
    } else {
        NSAssert([self.contentViewController conformsToProtocol:@protocol(YQContentViewControllerDelegate)], @"ContentViewController不是UINavigationController后者ContentViewController没有UINavigationController,请在ContentViewController中实现YQContentViewControllerDelegate协议");
        id<YQContentViewControllerDelegate> delegate = (id<YQContentViewControllerDelegate>)self.contentViewController;
        if ([delegate respondsToSelector:@selector(yq_navigationController)]) {
            UINavigationController *nav = [delegate yq_navigationController];
            NSAssert([nav isKindOfClass:[UINavigationController class]], @"yq_navigationController协议方法返回的不是UINavigationController");
            [nav pushViewController:viewController animated:NO];
            [self hideMenu];
        }
    }
    
}
- (void)hideMenu{
    if(!self.menuHidden || self.menuMoving){
        [self showMenu:NO];
    }
}
- (void)showMenu{
    if(self.menuHidden){
        [self showMenu:YES];
    }
}

#pragma custom selector

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)recongnizer{
    if(!self.menuHidden){
        [self hideMenu];
    }
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)recognizer{
    CGPoint point = [recognizer translationInView:self.view];
    CGFloat velocityX = [recognizer velocityInView:self.view].x;
    if (velocityX > MinTrigerSpeed) {
        [self showMenu:YES];
    } else if (velocityX < -MinTrigerSpeed) {
        [self showMenu:NO];
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.menuMoving = YES;
        [self updateContentViewShadow];
    }else if(recognizer.state == UIGestureRecognizerStateChanged){
    
        CGFloat menuVisibleWidth = self.view.bounds.size.width-self.realContentViewVisibleWidth;
        if (_scaleContent) {
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
        } else {
            CGRect frame = self.contentViewContainer.frame;
            CGFloat originX = frame.origin.x + point.x;
            if (originX > menuVisibleWidth){
                frame.origin.x = menuVisibleWidth;
            } else if(originX < 0) {
                frame.origin.x = 0;
            } else {
                frame.origin.x += point.x;
            }
            self.menuViewContainer.transform = CGAffineTransformMakeTranslation((1 - frame.origin.x / menuVisibleWidth) * (-menuVisibleWidth / 3), 0);
            self.contentViewContainer.frame = frame;
            [recognizer setTranslation:CGPointZero inView:self.view];
        }
        
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        [self showMenu: _scaleContent ? (self.contentViewScale < 1 - (1 - MinScaleContentView) / 2) : self.contentViewContainer.frame.origin.x > (self.view.bounds.size.width - self.realContentViewVisibleWidth) / 2];
        self.menuMoving = NO;
    } else if(recognizer.state == UIGestureRecognizerStateFailed || recognizer.state == UIGestureRecognizerStateCancelled) {
        [self hideMenu];
        self.menuMoving = NO;
    }
}
- (void)showMenu:(BOOL)show{
    if (_scaleContent) {
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
    } else {
        CGFloat menuWidth = self.view.bounds.size.width - self.realContentViewVisibleWidth;
        NSTimeInterval duration = (show ? (menuWidth - self.contentViewContainer.frame.origin.x) / menuWidth : self.contentViewContainer.frame.origin.x / menuWidth) * DurationAnimation;
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = self.contentViewContainer.frame;
            frame.origin.x =  show ? self.view.bounds.size.width - self.realContentViewVisibleWidth : 0;
            self.contentViewContainer.frame = frame;
            self.menuViewContainer.transform = show ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(-menuWidth / 3, 0);
        } completion:^(BOOL finished) {
            self.menuHidden = !show;
            self.gestureRecognizerView.hidden = !show;
        }];
    }
}

#pragma method assist
- (void)updateContentViewShadow {
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
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (self.menuHidden){
        if (point.x <= LeftMarginGesture){
            UINavigationController *nav = nil;
            if ([self.contentViewController isKindOfClass:[UINavigationController class]] ) {
                nav = (UINavigationController *)self.contentViewController;
            } else if ([self.contentViewController conformsToProtocol:@protocol(YQContentViewControllerDelegate)]) {
                id<YQContentViewControllerDelegate> delegate = (id<YQContentViewControllerDelegate>)self.contentViewController;
                nav = [delegate yq_navigationController];
            }
            if (nav) {
                if (nav.childViewControllers.count < 2) {
                    return YES;
                }
            } else {
                return YES;
            }
        }
    }else{
        return YES;
    }
    return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if(gestureRecognizer == self.edgePanGesture){
        return YES;
    }
    return  NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.edgePanGesture) {
        __block bool prior = NO;
        [self.priorGestures enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([otherGestureRecognizer isKindOfClass:obj]) {
                prior = YES;
                *stop = YES;
            }
        }];
        return prior;
    }
    return NO;
}

- (BOOL)shouldAutorotate {
    return _allowRotate;
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
