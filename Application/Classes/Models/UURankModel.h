//
//  ZXRankModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/17.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface ZXRankModel : JSONModel

@property (nonatomic,copy)NSString *rankingName;
@property (nonatomic,copy)NSString *rankingDescription1;
@property (nonatomic,copy)NSString *rankingDescription2;
@property (nonatomic,copy)NSString *cover;
@property (nonatomic,copy)NSString *argName;
@property (nonatomic,copy)NSString *argValue;

@end
