//
//  ZXButton.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXButton.h"

@implementation ZXButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (ZXButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title tintColor:(UIColor *)color titleColor:(UIColor *)titleColor{
    ZXButton *button = [ZXButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.tintColor = color;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateSelected];
    return button;
}
@end
