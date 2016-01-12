//
//  ZXReadCell.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXReadModel;
@interface ZXReadCell : UITableViewCell

@property (nonatomic,strong)UIImageView *readImageView;

@property (nonatomic,strong)ZXReadModel *model;

@end
