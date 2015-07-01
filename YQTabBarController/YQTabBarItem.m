//
//  YQTabBarItem.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/7/1.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "YQTabBarItem.h"

@interface YQTabBarItem ()
@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *highlightedImage;
@end

@implementation YQTabBarItem

- (instancetype)initWithNormalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage highlightedImage:(UIImage *)highlightedImage{
    if(self = [super init]){

        _normalImage = normalImage;
        _selectedImage = selectedImage;
        _highlightedImage = highlightedImage;
        
        self.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1];
        _barImgView = [[UIImageView alloc] init];
        [self addSubview:self.barImgView];
        
        _itemState = -1;
        self.itemState = YQTabBarItemStateNormal;

    }
    return self;
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//}
- (void)setItemState:(YQTabBarItemState)itemState{
    if(itemState != _itemState){
        _itemState = itemState;
        switch (itemState) {
            case YQTabBarItemStateNormal:{
                self.barImgView.image = self.normalImage;
            }
                break;
            case YQTabBarItemStateHighlight:{
                if(self.highlightedImage){
                    self.barImgView.image = self.highlightedImage;
                }
            }
                break;
            case YQTabBarItemStateSelect:{
                if(self.selectedImage){
                    self.barImgView.image = self.selectedImage;
                }
            }
                break;
            default:
                break;
        }
    }
}
- (void)setBgTopView:(UIView *)bgTopView{
    if(_bgTopView != bgTopView){
        _bgTopView = bgTopView;
        [self addSubview:_bgTopView];
        [self sendSubviewToBack:_bgTopView];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
