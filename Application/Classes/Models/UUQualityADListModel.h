//
//  ZXQualityADListModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"
#import "ZXQualityADModel.h"

@protocol ZXQualityADModel;
@interface ZXQualityADListModel : JSONModel

@property (nonatomic,strong)NSNumber *itemViewType;
@property (nonatomic,strong)NSArray<ZXQualityADModel> *galleryItems;

@property (nonatomic,strong)NSArray<ZXQualityADModel> *bannerItems;

@end
