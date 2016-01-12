//
//  ZXCollectionCell.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXCollectionCell.h"

@implementation ZXCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        _imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-20)];
        _imageView1.clipsToBounds = YES;
        _imageView1.layer.cornerRadius = _imageView1.frame.size.height/2.0;
        [self.contentView addSubview:_imageView1];
        
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView1.frame), _imageView1.frame.size.width, 20)];
        _label1.textAlignment = NSTextAlignmentCenter;
        _label1.textColor = [UIColor redColor];
        _label1.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_label1];

    }
    return self;
}

@end
