//
//  ZXRankCell.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/17.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXRankModel;
@interface ZXRankCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *rankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *description1Label;
@property (weak, nonatomic) IBOutlet UILabel *description2Label;

@property (nonatomic,strong)ZXRankModel *model;

@end
