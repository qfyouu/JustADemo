//
//  ZXFindBannerModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface ZXFindBannerModel : JSONModel

@property (nonatomic,copy)NSString *coverUrl;
@property (nonatomic,strong)NSNumber *type;
@property (nonatomic,copy)NSString *gotoUrl;
@property (nonatomic,strong)NSNumber *appId;



@end
