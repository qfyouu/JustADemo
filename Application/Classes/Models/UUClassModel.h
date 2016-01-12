//
//  ZXClassModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/18.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface ZXClassModel : JSONModel

@property (nonatomic,copy)NSString *sortId;
@property (nonatomic,copy)NSString *sortName;
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *iconSortName;
@property (nonatomic,copy)NSString *cover;
@property (nonatomic,copy)NSString *argCon;
@property (nonatomic,copy)NSString *argName;
@property (nonatomic,copy)NSString *argValue;

@end
