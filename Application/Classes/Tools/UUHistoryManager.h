//
//  ZXHistoryManager.h
//  CartoonStar
//
//  Created by 尤锐 on 15/8/24.
//  Copyright (c) 2015年 尤锐. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZXLIstModel;
@interface ZXHistoryManager : NSObject

+ (ZXHistoryManager *)sharedManager;

- (void)prepare;
- (BOOL)insert:(ZXLIstModel *)model andChapterName:(NSString *)chapterName;
- (BOOL)delete:(ZXLIstModel *)model ;
- (BOOL)deleteById:(NSString *)comic_id ;
- (NSMutableArray *)fetchAll;
- (BOOL)deleteAll;
- (BOOL)findModel:(ZXLIstModel *)model;

@end
