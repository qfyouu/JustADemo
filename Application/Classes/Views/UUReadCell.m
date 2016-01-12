//
//  ZXReadCell.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXReadCell.h"
#import "UIImageView+AFNetworking.h"

#import "ZXReadModel.h"

@implementation ZXReadCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)setModel:(ZXReadModel *)model{
    _readImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)];
    [_readImageView setImageWithURL:[NSURL URLWithString:model.location] placeholderImage:[[UIImage imageNamed:@"bg_default_potriat_change.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    
    [self.contentView addSubview:_readImageView];
}
@end
