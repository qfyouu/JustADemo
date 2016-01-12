//
//  ZXRankListCell.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/21.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXUpdateModel;
@interface ZXRankListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *symbolImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *clikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *extraValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *listLabel;


@property (nonatomic,strong)ZXUpdateModel *model;


@end
