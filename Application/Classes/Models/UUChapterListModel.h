//
//  ZXChapterListModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/19.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface ZXChapterListModel : JSONModel

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *image_total;
@property (nonatomic,copy)NSString *chapter_id;
@property (nonatomic,copy)NSString *size;
@property (nonatomic,strong)NSNumber *pass_time;
@property (nonatomic,copy)NSString *release_time;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,strong)NSNumber *is_view;
@property (nonatomic,copy)NSString *buyed;
@property (nonatomic,strong)NSNumber *read_state;


@end
