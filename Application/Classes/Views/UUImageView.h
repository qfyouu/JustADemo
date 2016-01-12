//
//  ZXImageView.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/18.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZXReModel;
@class ZXFindBannerModel;
@class ZXQualityADModel;
@class ZXSearchRecommendModel;
@interface ZXImageView : UIImageView

@property (nonatomic,strong)ZXQualityADModel *model;

@property (nonatomic,strong)ZXSearchRecommendModel *recommendModel;

@property (nonatomic,strong)ZXFindBannerModel *bannerModel;

@property (nonatomic,strong)ZXReModel *remodel;


@end
