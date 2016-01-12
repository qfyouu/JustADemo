//
//  ZXReModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface ZXReModel : JSONModel

@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSNumber *appId;
@property (nonatomic,copy)NSString *coverUrl;



@end
