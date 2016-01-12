//
//  ZXRecommendModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"
#import "ZXComicListItemsModel.h"

@protocol ZXComicListItemsModel;
@interface ZXRecommendModel : JSONModel

@property (nonatomic,strong)NSNumber *itemViewType;
@property (nonatomic,copy)NSString *argName;
@property (nonatomic,copy)NSString *argValue;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *titleIconUrl;
@property (nonatomic,copy)NSString *titleWithIcon;

@property (nonatomic,strong)NSArray<ZXComicListItemsModel> *comicListItems;


@end
