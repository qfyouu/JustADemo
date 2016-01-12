//
//  ZXNavgationBarView.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/14.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXNavgationBarView.h"

@implementation ZXNavgationBarView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 44)];
    if (self) {
        UIImage *image = [[UIImage imageNamed:@"titlebar_bg.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    return self;
}

- (UIImage *)scaleFromImage:(UIImage *)image toSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
}

@end
