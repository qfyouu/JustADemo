//
//  ZXRecommendCell.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXRecommendCell.h"
#import "UIImageView+AFNetworking.h"
#import "ZXUpdateModel.h"

@implementation ZXRecommendCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ZXUpdateModel *)model{
    _model = model;
    [_itemImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"bg_default_cover.png"]];
    _nameLabel.text = model.name;
    _authorLabel.text = model.nickname;
    _clickLabel.text = model.click_total;
    NSString *string = [model.tags componentsJoinedByString:@" "];
    _classLabel.text = string;
    _descriptionLabel.text = model.myDescription;
    
}

@end
