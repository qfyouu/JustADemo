//
//  ZXUpdateCell.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/17.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXUpdateModel;
@interface ZXUpdateCell : UITableViewCell

@property (nonatomic,strong)UIImageView *itemImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *nicknameLabel;
@property (nonatomic,strong)UILabel *click_totalLabel;
@property (nonatomic,strong)UILabel *tagsLabel;

@property (nonatomic,strong)UILabel *last_update_chapter_nameLabel;
@property (nonatomic,strong)UILabel *last_update_timeLabel;

@property (nonatomic,strong)ZXUpdateModel *model;

@property (nonatomic,strong)UIImageView *image;



@end
