//
//  ZXQualityADModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/15.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface ZXQualityADModel : JSONModel

@property (nonatomic,strong)NSNumber *bannerType;
@property (nonatomic,strong)NSNumber *linkType;
@property (nonatomic,copy)NSString *argName;
@property (nonatomic,strong)NSNumber *argValue;

@property (nonatomic,copy)NSString *specialTitle;
@property (nonatomic,copy)NSString *specialTopicId;
@property (nonatomic,copy)NSString *defaultImageUrl;
@property (nonatomic,copy)NSString *bigImageUrl;
@property (nonatomic,copy)NSString *smallImageUrl;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,strong)NSNumber *comicId;

@property (nonatomic,copy)NSString *wapUrl;




@end
