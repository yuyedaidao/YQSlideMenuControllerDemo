//
//  YQSlidMenuController.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/5/20.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "YQSlideMenuController.h"

static CGFloat const LeftMarginGesture = 30.0f;
static CGFloat const MinScaleContentView = 0.8f;
static double const DurationAnimation = 0.3f;
@interface YQSlideMenuController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *menuViewContainer;
@property (nonatomic, strong) UIView *contentViewContainer;
@property (nonatomic, strong) UIImageView *backgroundImageView;

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
    
    _contentViewShadowColor = [UIColor blackColor];
    _contentViewShadowOffset = CGSizeZero;
    _contentViewShadowOpacity = 0.4f;
    _contentViewShadowRadius = 8.0f;
    _contentViewVisibleWidth = 120.0f;
    _realContentViewVisibleWidth = _contentViewVisibleWidth/MinScaleContentView;
    _menuHidden = YES;
}
- (void)awakeFromNib{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    
//    UIScreenEdgePanGestureRecognizer *panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
//    panGesture.edges = UIRectEdgeLeft;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    panGesture.delegate = self;
    [self.contentViewContainer addGestureRecognizer:panGesture];
    
    [self updateContentViewShadow];
    
}
- (void)panGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)recognizer{
    
    CGPoint point = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self updateContentViewShadow];

    }else if(recognizer.state == UIGestureRecognizerStateChanged){

        CGFloat menuVisibleWidth = self.view.bounds.size.width-self.realContentViewVisibleWidth;
        CGFloat delta = self.menuHidden ? point.x/menuVisibleWidth : (menuVisibleWidth+point.x)/menuVisibleWidth;
        CGFloat scale = 1-(1-MinScaleContentView)*delta;
        if(self.menuHidden){
            if(scale < MinScaleContentView){
                self.contentViewContainer.transform = CGAffineTransformMakeTranslation(menuVisibleWidth, 0);
                self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform,MinScaleContentView,MinScaleContentView);
                self.contentViewScale = MinScaleContentView;
            }else{
                self.contentViewContainer.transform = CGAffineTransformMakeTranslation(point.x, 0);
                self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform,scale, scale);
                self.contentViewScale = scale;
            }

        }else{
            if(scale > 1){
                self.contentViewContainer.transform = CGAffineTransformMakeTranslation(0, 0);
                self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform,1,1);
                self.contentViewScale = 1;
            }else{
                self.contentViewContainer.transform = CGAffineTransformMakeTranslation(point.x+menuVisibleWidth, 0);
                self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform,scale, scale);
                self.contentViewScale = scale;
            }
        }
        
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        [self showMenu:(self.contentViewContainer.frame.origin.x > self.view.bounds.size.width/2)];
    }
}
- (void)showMenu:(BOOL)show{
    NSTimeInterval duration = (self.contentViewScale-MinScaleContentView)/(1-MinScaleContentView)*DurationAnimation;
    [UIView animateWithDuration:duration animations:^{
        if(show){
            self.contentViewContainer.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width-self.realContentViewVisibleWidth, 0);
            self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform,MinScaleContentView, MinScaleContentView);
            self.contentViewScale = MinScaleContentView;
        }else{
            self.contentViewContainer.transform = CGAffineTransformMakeTranslation(0, 0);
            self.contentViewContainer.transform = CGAffineTransformScale(self.contentViewContainer.transform,1, 1);
            self.contentViewScale = 1;
        }
    } completion:^(BOOL finished) {
        self.menuHidden = !show;
    }];
}
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
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if(self.menuHidden){
        if(point.x<=LeftMarginGesture){
            return YES;
        }
    }else{
        return YES;
    }
    
    return NO;
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
