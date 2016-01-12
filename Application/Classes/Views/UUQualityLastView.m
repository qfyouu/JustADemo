//
//  ZXQualityLastView.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/18.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXQualityLastView.h"
#import "ZXQualityADModel.h"
#import "UIImageView+AFNetworking.h"
#import "ZXImageView.h"
#import "ZXChoiceQualityViewController.h"
#import "ZXAppLIstViewController.h"
@implementation ZXQualityLastView

- (void)setArray:(NSArray *)array{
    _array = array;
    CGFloat width = (self.frame.size.width-3*10)/2.0;
    CGFloat height = width/2.0;
    for (int i=0; i<array.count; i++) {
        ZXQualityADModel *model = array[i];
        ZXImageView *imageView = [[ZXImageView alloc]initWithFrame:CGRectMake(10+(width+10)*(i%2), 10+(height+10)*(i/2), width, height)];
        [imageView setImageWithURL:[NSURL URLWithString:model.bigImageUrl] placeholderImage:[UIImage imageNamed:@"bg_default_recommend_bottom.png"]];
        imageView.userInteractionEnabled = YES;
        imageView.model = model;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    view.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:view];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
//    NSLog(@"123456");
    ZXImageView *imageView = (ZXImageView *)tap.view;
    
    ZXQualityADModel *model = imageView.model;
    
    NSDictionary *dic = @{@"comicid":model.comicId};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"last" object:self userInfo:dic];
}

@end
