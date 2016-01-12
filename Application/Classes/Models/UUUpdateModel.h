
//
//  ZXUpdateModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/17.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface ZXUpdateModel : JSONModel

@property (nonatomic,strong)NSNumber *comic_id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *cover;
@property (nonatomic,strong)NSNumber *accredit;

@property (nonatomic,strong)NSNumber *last_update_time;

@property (nonatomic,copy)NSString *last_update_chapter_name;
@property (nonatomic,copy)NSString *myDescription;
@property (nonatomic,strong)NSNumber *user_id;
@property (nonatomic,copy)NSString *nickname;
@property (nonatomic,copy)NSString *series_status;
@property (nonatomic,copy)NSString *theme_ids;
@property (nonatomic,strong)NSNumber *is_dujia;
@property (nonatomic,strong)NSArray *tags;
@property (nonatomic,copy)NSString *extraValue;
@property (nonatomic,copy)NSString *click_total;










@end
