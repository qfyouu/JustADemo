//
//  ZXLIstModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface ZXLIstModel : JSONModel

@property (nonatomic,copy)NSString *comic_id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *user_id;
@property (nonatomic,copy)NSString *author_name;
@property (nonatomic,copy)NSString *cover;
@property (nonatomic,copy)NSString *ori;
@property (nonatomic,copy)NSString *theme_ids;
@property (nonatomic,copy)NSString *cate_id;
@property (nonatomic,copy)NSString *read_order;
@property (nonatomic,copy)NSString *series_status;
@property (nonatomic,copy)NSString *last_update_time;
@property (nonatomic,copy)NSString *myDescription;
@property (nonatomic,copy)NSString *first_letter;
@property (nonatomic,copy)NSString *last_update_chapter_name;
@property (nonatomic,copy)NSString *last_update_chapter_id;
@property (nonatomic,copy)NSString *is_vip;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,strong)NSDictionary *thread;
@property (nonatomic,copy)NSString *click_total;
@property (nonatomic,strong)NSNumber *total_tucao;
@property (nonatomic,strong)NSNumber *month_ticket;
@property (nonatomic,strong)NSNumber *total_ticket;
@property (nonatomic,strong)NSNumber *comment_total;
@property (nonatomic,strong)NSNumber *total_hot;
@property (nonatomic,strong)NSNumber *is_dub;
@property (nonatomic,strong)NSNumber *image_all;
@property (nonatomic,strong)NSNumber *server_time;
@property (nonatomic,strong)NSNumber *avatar;



@end
