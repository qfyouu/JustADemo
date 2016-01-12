//
//  ZXSearchCell.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXSearchCell.h"

@implementation ZXSearchCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _nameLabel = [[UILabel alloc]initWithFrame:frame];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}
@end
