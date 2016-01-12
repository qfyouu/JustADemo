//
//  ZXQualityCell.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/17.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXQualityCell.h"

@implementation ZXQualityCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-20)];
        [self.contentView addSubview:_itemImageView];
        
        _itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_itemImageView.frame), _itemImageView.frame.size.width, 20)];
        _itemLabel.textAlignment = NSTextAlignmentCenter;
        _itemLabel.textColor = [UIColor redColor];
        _itemLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_itemLabel];
    }
    return self;
}
@end
