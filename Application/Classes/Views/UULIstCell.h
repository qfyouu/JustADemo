//
//  ZXLIstCell.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXChapterListModel;
@interface ZXLIstCell : UITableViewCell

@property (nonatomic,strong)UIButton *downloadButton;

@property (nonatomic,strong)UILabel *label;

@property (nonatomic,strong)ZXChapterListModel *model;



//@property (nonatomic,strong)UIImageView *bgImageView;



@end
