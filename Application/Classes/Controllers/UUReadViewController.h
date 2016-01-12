//
//  ZXReadViewController.h
//  CartoonStar
//
//  Created by qianfeng on 15/8/20.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"
@class ZXLIstModel;
@class ZXChapterListModel;
@interface ZXReadViewController : ViewController

@property (nonatomic,strong)ZXLIstModel *listModel;

@property (nonatomic,strong)ZXChapterListModel *model;


@property (nonatomic,assign)int currentChapter;
@property (nonatomic,assign)NSArray *sumDatas;

@property (nonatomic,assign)int maxChapter_id;

@end
