//
//  YQTabBarView.m
//  YQSlideMenuControllerDemo
//
//  Created by Wang on 15/6/30.
//  Copyright (c) 2015年 Wang. All rights reserved.
//

#import "YQTabBarView.h"

#define LOGCMD NSLog(@"%@:%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd))

@interface YQTabBarView ()
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, assign) YQTabBarItem *currentItem;
@end

@implementation YQTabBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithItemCount:(NSInteger)count{
    if(self = [super init]){
        _itemCount = count;
        _itemArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)loadItems{
   
    NSInteger defIndex = 0;
    if([self.delegate respondsToSelector:@selector(defaultSelectIndex)]){
        defIndex = [self.delegate defaultSelectIndex];
    }
    
    for (int i = 0; i < self.itemCount; i++) {
        YQTabBarItem *item = [self.delegate tabBarView:self itemForIndex:i];
        if(i == defIndex){
            item.itemState = YQTabBarItemStateSelect;
            self.currentItem = item;
        }
        [self.itemArray addObject:item];
        item.tag = i;
        [self addSubview:item];
        
        [item addTarget:self action:@selector(itemTouchDownAction:) forControlEvents:UIControlEventTouchDown];
        [item addTarget:self action:@selector(itemTouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        [item addTarget:self action:@selector(itemTouchCancelAction:) forControlEvents:UIControlEventTouchCancel];
        
    }
}
#pragma mark selector
- (void)itemTouchDownAction:(YQTabBarItem *)item{
    LOGCMD;
    if(self.currentItem != item){
        item.itemState = YQTabBarItemStateHighlight;
    }
}
- (void)itemTouchCancelAction:(YQTabBarItem *)item{
    LOGCMD;
    if(self.currentItem != item){
        item.itemState = YQTabBarItemStateNormal;
    }
}
- (void)itemTouchUpInsideAction:(YQTabBarItem *)item{
    LOGCMD;
    if(self.currentItem == item){
        return;
    }
    self.currentItem = item;
    
    if([self.delegate respondsToSelector:@selector(tabBarView:shouldSelectItemAtIndex:)]){
        
        if([self.delegate tabBarView:self shouldSelectItemAtIndex:item.tag]){
            if([self.delegate respondsToSelector:@selector(tabBarView:didSelectItemAtIndex:)]){
                
                [self.itemArray enumerateObjectsUsingBlock:^(YQTabBarItem *obj, NSUInteger idx, BOOL *stop) {
                    if(obj == item){
                        obj.itemState = YQTabBarItemStateSelect;
                    }else{
                        obj.itemState = YQTabBarItemStateNormal;
                    }
                }];
                
                if(self.tabBarItemClickedBlock){
                    self.tabBarItemClickedBlock(item.tag);
                }
                [self.delegate tabBarView:self didSelectItemAtIndex:item.tag];
            }
        }
    }

}
#pragma mark open api

- (YQTabBarItem *)tabBarItemForIndex:(NSInteger)index{
    if(index<self.itemCount){
        return self.itemArray[index];
    }
    return nil;
}


- (void)layoutSubviews{
    [super layoutSubviews];

    CGFloat itemWidth = CGRectGetWidth(self.bounds)/self.itemCount;
    [self.itemArray enumerateObjectsUsingBlock:^(YQTabBarItem *item, NSUInteger idx, BOOL *stop) {
        CGSize size = [self.delegate tabBarView:self sizeForItemAtIndex:idx];
        item.barImgView.frame = CGRectMake(0, 0, size.width, size.height);
        item.frame = CGRectMake(itemWidth*idx, 0, itemWidth, CGRectGetHeight(self.bounds));
        item.barImgView.center = CGPointMake(CGRectGetWidth(item.bounds)/2, CGRectGetHeight(item.bounds)/2);
    }];
}
@end
