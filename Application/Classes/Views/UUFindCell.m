//
//  ZXFindCell.m
//  CartoonStar
//
//  Created by qianfeng on 15/8/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ZXFindCell.h"
#import "ZXFindModel.h"
#import "UIImageView+AFNetworking.h"
#import "ZXDownLoadManager.h"

@interface ZXFindCell ()

//@property (nonatomic,strong)ZXDownLoadManager *manager;

@end

@implementation ZXFindCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(ZXFindListModel *)model{
    _model = model;
    [_itemImageView setImageWithURL:[NSURL URLWithString:model.coverUrl]placeholderImage:[UIImage imageNamed:@"umeng_socialize_share_pic.png"]];
    _nameLabel.text = model.title;
    _sizeLabel.text = [NSString stringWithFormat:@"%.2fMB",model.size.floatValue/1024/1024];
    _descLabel.text = model.desc;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)download:(UIButton *)button {
    NSDictionary *dic = @{@"button":button};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"downloadgame" object:self userInfo:dic];
    
}

@end
