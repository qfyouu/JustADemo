//
//  ZXGameModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/24.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface ZXGameModel : JSONModel

@property (nonatomic,strong)NSNumber *appId;
@property (nonatomic,copy)NSString *coverUrl;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)NSNumber *size;
@property (nonatomic,copy)NSString *desc;
@property (nonatomic,copy)NSString *dowmLoadUrl;
@property (nonatomic,copy)NSString *appPackageName;

@property (nonatomic,strong)NSArray *smallPictureUrls;
@property (nonatomic,strong)NSArray *bigPictureUrls;









@end
