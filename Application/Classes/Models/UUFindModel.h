//
//  ZXFindModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"
#import "ZXReModel.h"
#import "ZXFindListModel.h"
#import "ZXFindBannerModel.h"

@protocol ZXReModel;
@protocol ZXFindListModel;
@protocol ZXFindBannerModel;

@interface ZXFindModel : JSONModel
@property (nonatomic,strong)NSArray <ZXReModel>*recommands;
@property (nonatomic,strong)NSArray <ZXFindListModel>*itemList;
@property (nonatomic,strong)NSArray <ZXFindBannerModel>*banner;

@end
