//
//  ZXRankListCell.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXRankListCell.h"
#import "ZXUpdateModel.h"
#import "UIImageView+AFNetworking.h"
@implementation ZXRankListCell{

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ZXUpdateModel *)model{
//    static int system;
//    system++;
    _model = model;
    [_itemImageView setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"bg_default_cover.png"]];
    _nameLabel.text = model.name;
    _authorLabel.text = model.nickname;
    _clikeLabel.text = model.click_total;
    _classLabel.text = [model.tags componentsJoinedByString:@" "];
    _extraValueLabel.text = model.extraValue;
    //_listLabel.text = [NSString stringWithFormat:@"%d",system];

}
@end
