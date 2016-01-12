//
//  ZXSearchRecommendModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface ZXSearchRecommendModel : JSONModel

@property (nonatomic,strong)NSNumber *comicId;
@property (nonatomic,copy)NSString *coverUrl;
@property (nonatomic,copy)NSString *name;


@end
