//
//  ZXSearchListController.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"

@class ZXSearchModel;
@interface ZXSearchListController : ViewController

@property (nonatomic,strong)ZXSearchModel *model;

@property (nonatomic,copy)NSString *text;

@end
