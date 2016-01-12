//
//  ZXReadModel.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "JSONModel.h"

@interface ZXReadModel : JSONModel

@property (nonatomic,copy)NSString *location;
@property (nonatomic,copy)NSString *image_id;
@property (nonatomic,copy)NSString *width;
@property (nonatomic,copy)NSString *height;
@property (nonatomic,copy)NSString *total_tucao;
@property (nonatomic,copy)NSString *webp;
@property (nonatomic,copy)NSString *svol;
@property (nonatomic,copy)NSString *imag05;
@property (nonatomic,copy)NSString *imag50;

@end
