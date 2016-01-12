//
//  ZXQualityHeaderView.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/17.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXQualityHeaderView.h"

@implementation ZXQualityHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 2, self.frame.size.width, 1)];
//        view.backgroundColor = [UIColor darkGrayColor];
//        [self addSubview:view];
        _itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 40, self.frame.size.height-20)];
        [self addSubview:_itemImageView];
        _sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_itemImageView.frame), 15, 150, self.frame.size.height-30)];
        _sectionLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_sectionLabel];
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _moreButton.frame = CGRectMake(self.frame.size.width-70, 10, 50, self.frame.size.height-20);
        [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
        [self addSubview:_moreButton];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_moreButton.frame), 20, 10, self.frame.size.height-40)];
        imageView.image = [[UIImage imageNamed:@"icon_arrow.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self addSubview:imageView];
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_itemImageView.frame)+10, self.frame.size.width, 1)];
        view1.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:view1];

    }
    return self;
}
@end
